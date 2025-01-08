import 'package:flutter/material.dart';
import '../viewmodels/clock_view_model.dart';
import '../repositories/time_repository.dart';

/// デジタル時計の View クラス
/// 
/// このクラスは以下の特徴を持ちます：
/// - [StreamBuilder] を使用して Reactive な UI を構築
/// - [ClockViewModel] からの時刻データを購読
/// - setState を使用せずに UI を更新
class ClockView extends StatefulWidget {
  final TimeRepository? timeRepository;

  const ClockView({super.key, this.timeRepository});

  @override
  State<ClockView> createState() => _ClockViewState();
}

/// ClockView の State クラス
/// 
/// [ClockViewModel] のライフサイクルを管理し、
/// [StreamBuilder] を使用して時刻の表示を行います
class _ClockViewState extends State<ClockView> {
  late final ClockViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ClockViewModel(
      timeRepository: widget.timeRepository ?? SystemTimeRepository(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();  // ViewModel のリソースを解放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock'),
      ),
      body: Center(
        child: StreamBuilder<String>(
          // ViewModelから提供される時刻のStreamを購読
          stream: _viewModel.timeString,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Text(
              snapshot.data!,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
