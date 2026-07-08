import 'package:flutter/material.dart';
import '../../enums/paw_enums.dart';

// Các màn hình chính trong luồng nhận thưởng
enum AppScreen { completion, reward }

class PawRewardController extends ChangeNotifier {
  // Quản lý màn hình hiện tại đang hiển thị
  AppScreen _currentScreen = AppScreen.completion;
  AppScreen get currentScreen => _currentScreen;

  // Quản lý tọa độ bắt đầu và kết thúc của hiệu ứng bay
  Offset? _fromOffset;
  Offset? get fromOffset => _fromOffset;

  Offset? _toOffset;
  Offset? get toOffset => _toOffset;

  bool _showFlight = false;
  bool get showFlight => _showFlight;

  // Số điểm hiển thị trên Badge
  int _displayedPoints = 0;
  int get displayedPoints => _displayedPoints;

  // Tỷ lệ phóng to/thu nhỏ của Badge điểm số (tạo hiệu ứng nảy)
  double _badgeScale = 1.0;
  double get badgeScale => _badgeScale;

  // Giai đoạn hiện tại của màn hình reward
  RewardPhase _rewardPhase = RewardPhase.init;
  RewardPhase get rewardPhase => _rewardPhase;

  // Danh sách điểm thưởng tương ứng được chia cho từng hạt bay
  final List<int> _pointsPerParticle = [];
  List<int> get pointsPerParticle => _pointsPerParticle;

  // Bắt đầu chuỗi hiệu ứng nhận thưởng
  void startRewardAnimation(int awardedPoints, {required int finalBalance}) {
    _currentScreen = AppScreen.reward;
    _showFlight = false;
    _fromOffset = null;
    _toOffset = null;
    _rewardPhase = RewardPhase.init;

    // Bắt đầu từ số điểm đã trừ đi điểm thưởng
    final int startPoints = finalBalance - awardedPoints;
    _displayedPoints = startPoints < 0 ? 0 : startPoints;

    _badgeScale = 1.0;

    // Chia đều tổng số điểm thưởng cho 8 hạt bay chân mèo
    _pointsPerParticle.clear();
    final int base = awardedPoints ~/ 8;
    int remainder = awardedPoints % 8;
    for (int i = 0; i < 8; i++) {
      int pts = base;
      if (remainder > 0) {
        pts += 1;
        remainder--;
      }
      _pointsPerParticle.add(pts);
    }
    notifyListeners();
  }

  // Quay trở lại màn hình hoàn thành (Screen 1) và thực hiện đóng
  void goToCompletion(VoidCallback onClose) {
    _currentScreen = AppScreen.completion;
    _showFlight = false;
    _fromOffset = null;
    _toOffset = null;
    notifyListeners();
    onClose();
  }

  // Kích hoạt hiệu ứng bay của các hạt chân mèo con
  void triggerFlight(Offset from, Offset to) {
    _fromOffset = from;
    _toOffset = to;
    _showFlight = true;
    _rewardPhase = RewardPhase.fly;
    notifyListeners();
  }

  // Đặt thủ công phase
  void setPhase(RewardPhase phase) {
    _rewardPhase = phase;
    notifyListeners();
  }

  // Xử lý sự kiện khi một hạt chân mèo đáp vào tâm của Badge điểm số
  void onParticleLanded(int index) {
    if (index >= 0 && index < _pointsPerParticle.length) {
      // Cộng dồn điểm tương ứng của hạt đó vào Badge (kích hoạt nảy tự động trong DesignBadge)
      _displayedPoints += _pointsPerParticle[index];
      notifyListeners();
    }
  }
}
