import 'dart:async';
import '../repositories/time_repository.dart';

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
  final TimeRepository _timeRepository;
  Timer? _timer;
  DateTime? _latestValue;

  /// 時間の Stream を取得
  /// broadcast ストリームなので、複数の Widget で同時に購読可能
  Stream<DateTime> get timeStream => _timeController.stream;

  /// コンストラクタ
  /// [timeRepository] 時間を取得するためのリポジトリ
  /// 
  /// 依存性注入により、テスト時にモックリポジトリを注入可能
  TimeObservable(this._timeRepository) {
    _updateAndEmitTime();
    _startTimer();
  }

  /// 時間を更新してストリームに発行
  void _updateAndEmitTime() {
    _latestValue = _timeRepository.getCurrentTime();
    _timeController.add(_latestValue!);
  }

  /// 1秒ごとに新しい時間を発行するタイマーを開始
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateAndEmitTime();
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
