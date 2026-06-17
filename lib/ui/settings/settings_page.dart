import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../adapter/openai_adapter.dart';
import '../../app/di/providers.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/contracts/secret_store.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/models/chat_message.dart';

/// UI-05 最小设置页（手册 UI-05）。
/// M0 验收：填 provider/key/base_url/model → 点“测试”→ 收到模型流式回复。
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _baseUrlCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _keyCtrl = TextEditingController();
  LlmProvider _provider = LlmProvider.deepseek;

  bool _loaded = false;
  bool _testing = false;
  String _testOutput = '';
  String? _testError;

  bool _busy = false; // 导出/导入进行中
  String? _opsMsg; // 数据管理结果提示

  // PLACEHOLDER_METHODS

  Future<void> _export() async {
    setState(() {
      _busy = true;
      _opsMsg = null;
    });
    try {
      final json = await ref.read(backupServiceProvider).exportToJson();
      final dir = await getApplicationDocumentsDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final file = File(p.join(dir.path, 'virtual_backup_$ts.json'));
      await file.writeAsString(json);
      if (mounted) setState(() => _opsMsg = '已导出到：${file.path}');
    } catch (e) {
      if (mounted) setState(() => _opsMsg = '导出失败：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('导入备份？'),
        content: const Text('导入会覆盖当前所有数字人、聊天和记忆（API 配置保留）。确定继续？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('导入')),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _busy = true;
      _opsMsg = null;
    });
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (picked == null || picked.files.single.path == null) {
        if (mounted) setState(() => _busy = false);
        return;
      }
      final json = await File(picked.files.single.path!).readAsString();
      await ref.read(backupServiceProvider).importFromJson(json);
      if (mounted) setState(() => _opsMsg = '导入完成，重启或返回首页可见。');
    } catch (e) {
      if (mounted) setState(() => _opsMsg = '导入失败：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await ref.read(settingsRepoProvider).get();
    final key = await ref.read(secretStoreProvider).read(SecretKeys.apiKey);
    setState(() {
      _provider = settings.provider;
      _baseUrlCtrl.text = settings.baseUrl;
      _modelCtrl.text = settings.model;
      _keyCtrl.text = key ?? '';
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final current = await ref.read(settingsRepoProvider).get();
    await ref.read(settingsRepoProvider).update(
          current.copyWith(
            provider: _provider,
            baseUrl: _baseUrlCtrl.text.trim(),
            model: _modelCtrl.text.trim(),
          ),
        );
    final key = _keyCtrl.text.trim();
    final store = ref.read(secretStoreProvider);
    if (key.isEmpty) {
      await store.delete(SecretKeys.apiKey);
    } else {
      await store.write(SecretKeys.apiKey, key);
    }
    // 配置变了，让依赖它的 provider 重建。
    ref.invalidate(settingsProvider);
    ref.invalidate(modelAdapterProvider);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('已保存')));
    }
  }

  Future<void> _test() async {
    await _save();
    setState(() {
      _testing = true;
      _testOutput = '';
      _testError = null;
    });
    try {
      final ModelAdapter adapter = OpenAIAdapter(
        baseUrl: _baseUrlCtrl.text.trim(),
        apiKey: _keyCtrl.text.trim(),
        model: _modelCtrl.text.trim(),
      );
      final stream = adapter.chat(
        system: '你是一个友好的助手。',
        messages: [Msg.user('用一句话跟我打个招呼。')],
      );
      await for (final chunk in stream) {
        if (!mounted) return;
        setState(() => _testOutput += chunk);
      }
    } catch (e) {
      if (mounted) setState(() => _testError = e.toString());
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('设置 · 模型')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<LlmProvider>(
            initialValue: _provider,
            decoration: const InputDecoration(labelText: '服务商 provider'),
            items: LlmProvider.values
                .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                .toList(),
            onChanged: (v) => setState(() => _provider = v ?? _provider),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _baseUrlCtrl,
            decoration: const InputDecoration(
              labelText: 'base_url',
              hintText: 'https://api.deepseek.com',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _modelCtrl,
            decoration: const InputDecoration(
              labelText: 'model',
              hintText: 'deepseek-chat',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _keyCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'API Key（仅存本机加密存储，不入数据库）',
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _testing ? null : _save,
                  child: const Text('保存'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _testing ? null : _test,
                  child: Text(_testing ? '测试中…' : '测试'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_testError != null)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text('出错：$_testError'),
              ),
            )
          else if (_testOutput.isNotEmpty || _testing)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _testOutput.isEmpty ? '等待模型响应…' : _testOutput,
                ),
              ),
            ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          const Text('数据管理',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _export,
                  icon: const Icon(Icons.download),
                  label: const Text('导出备份'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _import,
                  icon: const Icon(Icons.upload),
                  label: const Text('导入备份'),
                ),
              ),
            ],
          ),
          if (_opsMsg != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_opsMsg!,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          const Text('隐私说明',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text(
            '· 你的 API Key 只存在本机加密存储里，绝不上传、绝不入数据库。\n'
            '· 聊天记录、人格、记忆全部存在本地设备。\n'
            '· 但对话与建号分析会把相应内容发送给你所选的 AI 服务商'
            '（DeepSeek / OpenAI 等）用于生成回复——这是 BYOK 模式的必要环节。\n'
            '· 备份文件不含 API Key，可放心保存/迁移。',
            style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _baseUrlCtrl.dispose();
    _modelCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }
}