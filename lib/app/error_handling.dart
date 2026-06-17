import 'package:flutter/foundation.dart';

/// 极简全局日志（手册 INFRA-01）。
///
/// 安全约定：**绝不**记录 API key 或其它密钥。需要打印配置时，
/// 调用方自行剔除敏感字段。
class Log {
  static void d(String msg) {
    if (kDebugMode) debugPrint('[D] $msg');
  }

  static void e(String msg, [Object? error, StackTrace? st]) {
    debugPrint('[E] $msg${error != null ? ' :: $error' : ''}');
    if (st != null && kDebugMode) debugPrint(st.toString());
  }
}

/// 安装全局错误处理。在 runApp 前调用。
void installGlobalErrorHandling() {
  FlutterError.onError = (details) {
    Log.e('FlutterError', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    Log.e('Uncaught', error, stack);
    return true;
  };
}
