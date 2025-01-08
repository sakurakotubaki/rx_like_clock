/// 時間データの取得を抽象化するインターフェース
abstract interface class TimeRepository {
  /// 現在時刻を取得
  DateTime getCurrentTime();
}

/// 実際のシステム時間を使用する TimeRepository の実装
class SystemTimeRepository implements TimeRepository {
  @override
  DateTime getCurrentTime() {
    return DateTime.now();
  }
}

/// テスト用の固定時間を返す TimeRepository の実装
class MockTimeRepository implements TimeRepository {
  final DateTime fixedTime;

  MockTimeRepository(this.fixedTime);

  @override
  DateTime getCurrentTime() {
    return fixedTime;
  }
}
