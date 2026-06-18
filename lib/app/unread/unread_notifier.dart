import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';

/// 未读追踪器——暴露各数字人的未读消息数 + 标已读。
///
/// 只统计对方发来的消息（sender = 'persona'）中 read_at IS NULL 的。
class UnreadNotifier extends StateNotifier<Map<int, int>> {
  final AppDatabase db;

  UnreadNotifier(this.db) : super({}) {
    refresh();
  }

  /// 刷新未读计数。UI 可主动调用（进首页、返回聊天页等）。
  Future<void> refresh() async {
    final rows = await db.customSelect(
      'SELECT persona_id, COUNT(*) as cnt '
      'FROM messages '
      'WHERE sender = \'persona\' AND read_at IS NULL '
      'GROUP BY persona_id',
    ).get();
    final map = <int, int>{};
    for (final r in rows) {
      final pid = r.read<int>('persona_id');
      final cnt = r.read<int>('cnt');
      map[pid] = cnt;
    }
    if (!_mapsEqual(state, map)) {
      state = map;
    }
  }

  /// 把某个数字人的所有未读消息标为已读。
  Future<void> markAsRead(int personaId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    // 用 customStatement 避免 drift 表达式组合的类型推断问题。
    await db.customStatement(
      'UPDATE messages SET read_at = ? '
      'WHERE persona_id = ? AND sender = \'persona\' AND read_at IS NULL',
      [now, personaId],
    );
    await refresh();
  }

  /// 当前总未读数（给 Tab 角标用）。
  int get total =>
      state.values.fold(0, (int a, int b) => a + b);

  static bool _mapsEqual(Map<int, int> a, Map<int, int> b) {
    if (a.length != b.length) return false;
    for (final k in a.keys) {
      if (a[k] != b[k]) return false;
    }
    return true;
  }
}
