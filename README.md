# RxLike Clock

FlutterでRxパターンを学習するためのデジタル時計アプリケーション。
setStateを使用せずに、StreamとMVVMパターンを使用して実装しています。

## 主要な概念

### Broadcast Stream
Dartの`StreamController.broadcast()`を使用して、Hot Observableパターンを実装しています。

```dart
// 複数のリスナーが購読可能なブロードキャストストリーム
final StreamController<DateTime> _timeController = 
    StreamController<DateTime>.broadcast();

// 使用例
timeController.stream.listen((time) => print('Listener 1: $time')); // OK
timeController.stream.listen((time) => print('Listener 2: $time')); // OK
```

### MVVMアーキテクチャ

#### Model (TimeObservable)
時間データのストリームを管理します。
```dart
class TimeObservable {
  final StreamController<DateTime> _timeController = 
      StreamController<DateTime>.broadcast();
  final TimeRepository _timeRepository;
  
  Stream<DateTime> get timeStream => _timeController.stream;
  
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (_) {
      _timeController.add(_timeRepository.getCurrentTime());
    });
  }
}
```

#### ViewModel (ClockViewModel)
時間データを表示用の文字列に変換します。
```dart
class ClockViewModel {
  final TimeObservable _timeObservable;
  
  Stream<String> get timeString => _timeObservable.timeStream
      .map((time) => _formatTime(time));
      
  String _formatTime(DateTime time) => 
      '${_padZero(time.hour)}:${_padZero(time.minute)}:${_padZero(time.second)}';
}
```

#### View (ClockView)
`StreamBuilder`を使用して時刻を表示します。
```dart
StreamBuilder<String>(
  stream: _viewModel.timeString,
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    return Text(
      snapshot.data!,
      style: TextStyle(fontSize: 60),
    );
  },
)
```

### 依存性注入（DI）
テスト容易性と拡張性のために、TimeRepositoryを注入可能な設計にしています。

```dart
// インターフェース
abstract interface class TimeRepository {
  DateTime getCurrentTime();
}

// 実装
class SystemTimeRepository implements TimeRepository {
  @override
  DateTime getCurrentTime() => DateTime.now();
}

// テスト用モック
class MockTimeRepository implements TimeRepository {
  final DateTime fixedTime;
  MockTimeRepository(this.fixedTime);
  
  @override
  DateTime getCurrentTime() => fixedTime;
}
```

## Hot Observable vs Cold Observable

### Hot Observable (使用中)
- 購読者の有無に関係なくデータを発行
- 複数の購読者で同じデータストリームを共有
- 購読開始時点以降のデータのみを受信
- 例：マウスの移動、センサーデータ、時間の流れ

### Cold Observable
- 購読者ごとに個別のデータストリームを生成
- 購読開始時に最初からデータを受信
- 例：HTTPリクエスト、ファイル読み込み

## 参考リンク
- [Dart Streams](https://dart.dev/tutorials/language/streams)
- [ReactiveX](https://reactivex.io/)
- [Flutter StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
