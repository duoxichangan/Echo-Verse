import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../domain/contracts/model_adapter.dart';
import '../domain/models/chat_message.dart';

/// 适配器异常（统一对外暴露，便于 UI 友好提示）。
class ModelAdapterException implements Exception {
  final String message;
  final int? statusCode;
  ModelAdapterException(this.message, {this.statusCode});
  @override
  String toString() => 'ModelAdapterException($statusCode): $message';
}

/// OpenAI 格式适配器（手册 MODEL-01）。
///
/// DeepSeek 与 GPT 共用：均为 OpenAI 的 `/chat/completions` + SSE 流式。
/// API key 由调用方在构造时注入（来自 SecretStore），本类不持久化它。
class OpenAIAdapter implements ModelAdapter {
  final Dio _dio;
  final String baseUrl;
  final String apiKey;
  final String model;

  /// 流式失败时的重试次数（仅对连接/超时类错误重试）。
  final int maxRetries;

  OpenAIAdapter({
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    this.maxRetries = 2,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  Stream<String> chat({
    required String system,
    required List<Msg> messages,
    ChatOpts opts = const ChatOpts(),
  }) async* {
    final url = '${_trimSlash(baseUrl)}/chat/completions';
    final body = <String, dynamic>{
      'model': model,
      'stream': true,
      'temperature': opts.temperature,
      if (opts.maxTokens != null) 'max_tokens': opts.maxTokens,
      if (opts.topP != null) 'top_p': opts.topP,
      'messages': [
        if (system.isNotEmpty) Msg.system(system).toOpenAiJson(),
        ...messages.map((m) => m.toOpenAiJson()),
      ],
    };

    var attempt = 0;
    while (true) {
      try {
        yield* _streamOnce(url, body, opts);
        return;
      } on ModelAdapterException {
        rethrow; // HTTP 层明确错误不重试
      } catch (e) {
        attempt++;
        if (attempt > maxRetries) {
          throw ModelAdapterException('网络异常，已重试 $maxRetries 次：$e');
        }
        await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
      }
    }
  }

  Stream<String> _streamOnce(
    String url,
    Map<String, dynamic> body,
    ChatOpts opts,
  ) async* {
    final response = await _dio.post<ResponseBody>(
      url,
      data: jsonEncode(body),
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'Accept': 'text/event-stream',
        },
        sendTimeout: Duration(milliseconds: opts.timeoutMs ?? 30000),
        receiveTimeout: Duration(milliseconds: opts.timeoutMs ?? 60000),
        // 我们自己处理非 2xx，避免 dio 抛裸异常吞掉响应体
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode == null || response.statusCode! >= 400) {
      final errText = await _drain(response.data!);
      throw ModelAdapterException(
        _extractError(errText),
        statusCode: response.statusCode,
      );
    }

    // SSE：按行解析 `data: {...}`，遇到 [DONE] 结束。
    final stream = response.data!.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in stream) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || !trimmed.startsWith('data:')) continue;
      final data = trimmed.substring(5).trim();
      if (data == '[DONE]') return;
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        final choices = json['choices'] as List?;
        if (choices == null || choices.isEmpty) continue;
        final delta = (choices.first as Map)['delta'] as Map?;
        final content = delta?['content'] as String?;
        if (content != null && content.isNotEmpty) {
          yield content;
        }
      } catch (_) {
        // 单行畸形不致命，跳过继续（R5 鲁棒性精神）
        continue;
      }
    }
  }

  Future<String> _drain(ResponseBody body) async {
    final chunks = <int>[];
    await for (final c in body.stream) {
      chunks.addAll(c);
    }
    return utf8.decode(chunks, allowMalformed: true);
  }

  String _extractError(String raw) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final err = json['error'];
      if (err is Map && err['message'] is String) return err['message'] as String;
    } catch (_) {}
    return raw.isEmpty ? '请求失败' : raw;
  }

  String _trimSlash(String s) => s.endsWith('/') ? s.substring(0, s.length - 1) : s;
}
