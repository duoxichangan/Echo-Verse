import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../domain/contracts/chat_log_parser.dart';
import '../../domain/contracts/persona_builder.dart';
import '../chat/wechat_theme.dart';

/// txt 导入建号向导（手册 PERSONA-01/02 / 说明书 §4.1 §14.2）。
///
/// 上传 txt → LLM 解析（含采样上限提示）→ 预览（条数/双方/跨度）→ 指认复刻对象
/// + 补设定 → LLM 提炼画像 → 落库。
class ImportPersonaPage extends ConsumerStatefulWidget {
  const ImportPersonaPage({super.key});

  @override
  ConsumerState<ImportPersonaPage> createState() => _ImportPersonaPageState();
}

enum _Step { pick, parsing, review, building }

class _ImportPersonaPageState extends ConsumerState<ImportPersonaPage> {
  _Step _step = _Step.pick;
  String? _error;
  String? _buildProgress; // 多轮凝练进度文案

  ParsedLog? _log;
  String? _fileName;

  // 设定。
  String? _targetSpeaker;
  final _name = TextEditingController();
  final _relationship = TextEditingController();
  final _alias = TextEditingController();
  final _traits = TextEditingController();

  Future<void> _pickAndParse() async {
    setState(() => _error = null);
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        withData: false,
      );
      if (picked == null || picked.files.isEmpty) return;
      final path = picked.files.single.path;
      if (path == null) {
        setState(() => _error = '无法读取文件路径');
        return;
      }
      _fileName = picked.files.single.name;
      final raw = await File(path).readAsString();

      setState(() => _step = _Step.parsing);
      final parser = await ref.read(chatLogParserProvider.future);
      final log = await parser.parse(raw);

      if (!mounted) return;
      setState(() {
        _log = log;
        _targetSpeaker = log.speakers.isNotEmpty ? log.speakers.first : null;
        if (_targetSpeaker != null) _name.text = _targetSpeaker!;
        _step = _Step.review;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '解析失败：$e';
          _step = _Step.pick;
        });
      }
    }
  }

  Future<void> _build() async {
    final log = _log;
    if (log == null || _name.text.trim().isEmpty) return;
    setState(() {
      _step = _Step.building;
      _error = null;
    });
    try {
      final builder = await ref.read(personaBuilderProvider.future);
      final hints = PersonaHints(
        name: _name.text.trim(),
        targetSpeaker: _targetSpeaker,
        relationship: _empty(_relationship.text),
        userAlias: _empty(_alias.text),
        personalityHints: _empty(_traits.text),
      );
      final profile = await builder.build(
        log,
        hints,
        onProgress: (done, total) {
          if (mounted) {
            setState(() => _buildProgress = total > 1 ? '正在提炼人格… $done/$total' : null);
          }
        },
      );
      await ref.read(personaRepoProvider).create(
            name: hints.name,
            personaJson: profile.toJsonString(),
            userAlias: hints.userAlias,
            relationship: hints.relationship,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '生成画像失败：$e';
          _step = _Step.review;
        });
      }
    }
  }

  String? _empty(String s) => s.trim().isEmpty ? null : s.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeChat.bg,
      appBar: AppBar(
        backgroundColor: WeChat.barBg,
        foregroundColor: WeChat.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: WeChat.divider, width: 0.5)),
        title: const Text('从聊天记录导入',
            style: TextStyle(fontWeight: FontWeight.w600, color: WeChat.textPrimary, fontSize: 17)),
        centerTitle: true,
      ),
      body: switch (_step) {
        _Step.pick => _pickView(),
        _Step.parsing => _busy('正在解析聊天记录…\n（条数多时会花一点 token，请稍候）'),
        _Step.review => _reviewView(),
        _Step.building => _busy(_buildProgress == null
            ? '正在提炼人格画像…'
            : '$_buildProgress\n（读完全部记录、逐批凝练，请稍候）'),
      },
    );
  }

  Widget _busy(String text) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: WeChat.textHint)),
          ],
        ),
      );

  Widget _pickView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.description_outlined, size: 56, color: WeChat.brand),
        const SizedBox(height: 16),
        const Text('选择一个聊天记录 txt 文件',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: WeChat.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          '记录会发送给你配置的 AI 服务商用于分析（隐私说明见设置）。\n条数过多时只分析最近一部分，避免过度消耗。',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: WeChat.textHint),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _pickAndParse,
          icon: const Icon(Icons.upload_file),
          label: const Text('选择文件'),
          style: FilledButton.styleFrom(
            backgroundColor: WeChat.brand,
            minimumSize: const Size.fromHeight(48),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
        ],
      ],
    );
  }

  Widget _reviewView() {
    final log = _log!;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _previewCard(log),
              const SizedBox(height: 16),
              const Text('要复刻谁？', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (log.speakers.isEmpty)
                const Text('没识别出说话人，可直接填昵称创建',
                    style: TextStyle(color: WeChat.textHint, fontSize: 13))
              else
                Wrap(
                  spacing: 8,
                  children: log.speakers
                      .map((s) => ChoiceChip(
                            label: Text(s),
                            selected: _targetSpeaker == s,
                            selectedColor: WeChat.brand.withValues(alpha: 0.2),
                            onSelected: (_) => setState(() {
                              _targetSpeaker = s;
                              if (_name.text.trim().isEmpty) _name.text = s;
                            }),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 16),
              _field('昵称 *', _name, '给 TA 起个名字'),
              _field('和你的关系', _relationship, '女朋友 / 好友…'),
              _field('TA 怎么称呼你', _alias, '笨蛋 / 你的名字…'),
              _field('性格关键词', _traits, '温柔、毒舌…', maxLines: 2),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton(
              onPressed: _name.text.trim().isEmpty ? null : _build,
              style: FilledButton.styleFrom(
                backgroundColor: WeChat.brand,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('提炼人格并创建'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _previewCard(ParsedLog log) {
    final bySpeaker = <String, int>{};
    for (final m in log.messages) {
      bySpeaker[m.speaker] = (bySpeaker[m.speaker] ?? 0) + 1;
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WeChat.bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('文件：${_fileName ?? ''}',
              style: const TextStyle(color: WeChat.textHint, fontSize: 12)),
          const SizedBox(height: 6),
          Text('识别出 ${log.messages.length} 条消息',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          if (log.span.isNotEmpty)
            Text('时间跨度：${log.span}',
                style: const TextStyle(color: WeChat.textHint, fontSize: 13)),
          const SizedBox(height: 6),
          ...bySpeaker.entries.map((e) => Text('· ${e.key}：${e.value} 条',
              style: const TextStyle(fontSize: 13))),
          if (log.sampled) ...[
            const SizedBox(height: 8),
            Text(
              '⚠️ 原文较长（约 ${log.estimatedTotal} 行），只分析了最近一部分以控制消耗。',
              style: const TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: WeChat.inputFieldBg,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: WeChat.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: WeChat.divider),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _relationship.dispose();
    _alias.dispose();
    _traits.dispose();
    super.dispose();
  }
}
