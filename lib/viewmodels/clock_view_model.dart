import 'dart:async';
import '../models/time_observable.dart';

/// 時計の ViewModel クラス
/// 
/// このクラスは以下の責務を持ちます：
/// - [TimeObservable] からの時間データの受け取り
/// - 時間データの文字列フォーマットへの変換
/// - View層への加工済みデータの提供
class ClockViewModel {
  final TimeObservable _timeObservable = TimeObservable();
  
  /// 時刻を "HH:mm:ss" 形式の文字列として提供する Stream
  /// 
  /// Stream<DateTime> を Stream<String> に変換（map）することで、
  /// View層で直接表示可能な形式にデータを加工します
  Stream<String> get timeString => _timeObservable.timeStream
      .map((dateTime) => _formatTime(dateTime));

  /// DateTime を "HH:mm:ss" 形式の文字列に変換
  String _formatTime(DateTime dateTime) {
    return '${_padZero(dateTime.hour)}:${_padZero(dateTime.minute)}:${_padZero(dateTime.second)}';
  }

  /// 数値を2桁の文字列に変換（例: 1 → "01"）
  String _padZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  /// リソースの解放
  void dispose() {
    _timeObservable.dispose();
  }
}
