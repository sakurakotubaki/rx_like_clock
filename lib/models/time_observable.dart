import 'dart:async';

/// Rxパターンを実装した時間の Observable クラス
///
/// このクラスは時間のストリームを提供し、以下の特徴があります：
/// - [StreamController.broadcast] を使用して Hot Observable として実装
/// - 最新の時間値を [_latestValue] として保持
/// - 1秒ごとに新しい時間を発行
class TimeObservable {
  // broadcast()を使用することで、複数のリスナーがストリームを購読可能
  final StreamController<DateTime> _timeController =
      StreamController<DateTime>.broadcast();
  Timer? _timer;
  DateTime? _latestValue;

  /// 時間の Stream を取得
  /// broadcast ストリームなので、複数の Widget で同時に購読可能
  Stream<DateTime> get timeStream => _timeController.stream;

  /// デフォルトコンストラクタ
  /// - [_latestValue] を現在の日時に初期化
  /// - [_timeController] に現在の日時を発行
  /// - [_startTimer] を呼び出して 1秒ごとに新しい時間を発行
  TimeObservable() {
    _latestValue = DateTime.now();
    _timeController.add(_latestValue!);
    _startTimer();
  }

  /// 1秒ごとに新しい時間を発行するタイマーを開始
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _latestValue = DateTime.now();
      _timeController.add(_latestValue!);
    });
  }

  /// リソースの解放
  /// - タイマーのキャンセル
  /// - StreamController のクローズ
  void dispose() {
    _timer?.cancel();
    _timeController.close();
  }
}
