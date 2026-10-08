import 'package:flutter/material.dart';
import 'package:paw_anim/paw_anim.dart';

void main() => runApp(const PawExampleApp());

class PawExampleApp extends StatelessWidget {
  const PawExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paw Animation Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  static const awardedPoints = 10;
  static const finalBalance = 150;
  static const backgroundColor = Color(0xFF35256B);
  static const mascot = SizedBox(
    width: 260,
    height: 220,
    child: Icon(Icons.pets, size: 140, color: Colors.amber),
  );

  void _showCommon(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0x99000000),
      builder: (dialogContext) => PawCommonClaimReward(
        awardedPoints: awardedPoints,
        finalBalance: finalBalance,
        onDone: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }

  void _showSimulator(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierColor: backgroundColor,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return PawSimulatorClaimReward(
          awardedPoints: awardedPoints,
          finalBalance: finalBalance,
          mascot: mascot,
          resultBox: const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Hoàn thành chặng học!\n+$awardedPoints chân mèo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          onClose: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }

  void _showResult(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (routeContext) => PawSimulatorRewardResultScreen(
          awardedPoints: awardedPoints,
          finalBalance: finalBalance,
          onClose: () => Navigator.of(routeContext).pop(),
          background: const ColoredBox(color: backgroundColor),
          mascot: mascot,
          title: const Text(
            'Hoàn thành bài tập!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text(
            'Bạn đã nhận thêm $awardedPoints chân mèo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          statColumn1: const _Stat(label: 'Chính xác', value: '90%'),
          statColumn2: const _Stat(label: 'Thời gian', value: '02:30'),
          rewardLabel: const Text(
            'Thưởng',
            style: TextStyle(color: Colors.white70),
          ),
          rewardValueStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paw Animation Example')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              const Icon(Icons.pets, size: 72, color: Colors.deepPurple),
              const SizedBox(height: 24),
              const Text(
                'Chọn hiệu ứng để chạy thử.\n'
                'Điểm thưởng: $awardedPoints • Số dư sau thưởng: $finalBalance',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => _showCommon(context),
                child: const Text('PawCommonClaimReward'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _showSimulator(context),
                child: const Text('PawSimulatorClaimReward'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _showResult(context),
                child: const Text('PawSimulatorRewardResultScreen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
