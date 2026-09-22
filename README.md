# paw_anim

Một package Flutter chuyên dụng để quản lý, biểu diễn hiệu ứng hoạt họa và phần thưởng "Chân mèo" (Cat Paw Animation) trong hệ sinh thái Loyalty của ứng dụng Vuihoc.

Package này được tách độc lập để giảm tải logic cho dự án chính, đồng thời giữ các dependencies tối thiểu nhằm tránh xung đột phiên bản (diamond dependency).

## 📌 Tính năng chính

Package cung cấp 3 thành phần giao diện động chính:

1. **PawCommonClaimReward**: Widget hiển thị popup nhận thưởng chung (Confetti rơi, đếm tích lũy điểm và bay hạt chân mèo đến góc phải trên cùng).
2. **PawSimulatorClaimReward**: Màn hình chúc mừng hoàn thành chặng học tập trong phòng mô phỏng (Simulator).
3. **PawSimulatorRewardResultScreen**: Màn hình hiển thị chi tiết kết quả và điểm thưởng chân mèo khi hoàn thành bài tập.

---

## 🛠️ Thiết kế Kiến trúc và Decoupling

Để tối giản hóa các dependencies và tránh nhúng logic nghiệp vụ của ứng dụng chính vào thư viện:
* **Không chứa Audio / Sound effects**: Mọi tài nguyên âm thanh và logic chạy âm thanh (`AudioPlayer`) được xử lý hoàn toàn ở phía Wrapper Widget của ứng dụng chính trong hàm `initState` khi khởi tạo Widget.
* **Không chứa Business Logic**: Thư viện chỉ nhận dữ liệu hiển thị (ví dụ `awardedPoints`, `finalBalance`) và các callback điều hướng từ ứng dụng chính thông qua các event/callback interface.
* **Tự đóng gói Assets**: Mọi hình ảnh vector SVG liên quan đến phần chân mèo (`cat_paws.svg`) được cấu hình nằm trực tiếp bên trong thư viện và được gọi thông qua định danh package.

---

## Chạy app example

Thư mục [`example/`](example/) chứa app Flutter chạy thử cả ba màn hình nhận thưởng trên Android, iOS và web.

```sh
cd example
flutter pub get
flutter run
```

App dùng package local qua `path: ../`. Xem thêm tại [`example/README.md`](example/README.md).

## 🚀 Hướng dẫn sử dụng

### 1. Thêm dependency vào dự án chính (`pubspec.yaml`)

```yaml
dependencies:
  paw_anim:
    git:
      url: git@github.com:vuihoc-edtech/cat_paws_animation.git
      ref: main
```

### 2. Ví dụ cách gọi Widget trong ứng dụng chính

#### a) Sử dụng `PawCommonClaimReward`
```dart
import 'package:paw_anim/paw_anim.dart';

showDialog(
  context: context,
  barrierColor: const Color(0x66000000),
  builder: (context) => PawCommonClaimReward(
    awardedPoints: 10,
    finalBalance: 150,
    onDone: () {
      Navigator.of(context).pop();
    },
  ),
);
```

#### b) Sử dụng `PawSimulatorClaimReward`
```dart
import 'package:paw_anim/paw_anim.dart';

showGeneralDialog(
  context: context,
  pageBuilder: (context, _, __) => PawSimulatorClaimReward(
    awardedPoints: 5,
    finalBalance: 155,
    mascot: Image.asset('assets/mascot.png'),
    resultBox: CustomResultBox(points: 5, cup: 1),
    onClose: () => Navigator.of(context).pop(),
    onAnimationComplete: () {
      print('Hiệu ứng bay hoàn thành!');
    },
  ),
);
```

---

## 📂 Cấu trúc thư mục của Package

```text
paw_anim/
├── assets/                  # Tài nguyên tĩnh đi kèm (cat_paws.svg)
├── example/                 # App Flutter chạy thử package
├── lib/
│   ├── paw_anim.dart        # Entry point xuất bản các Widget công khai
│   └── src/
│       ├── colors/          # Định nghĩa bảng màu gradient/glow dùng cho hoạt họa
│       ├── enums/           # Quản lý giai đoạn trạng thái nhận thưởng
│       ├── models/          # Các thực thể dữ liệu phụ trợ cho Particle & Confetti
│       ├── utils/           # Các hàm định dạng điểm, mở rộng animation
│       └── widgets/
│           ├── common/      # Chứa PawRewardScreen, FlightParticles, BigPaw...
│           └── simulator/   # Chứa các overlay hạt bay, bảng điểm chặng Simulator
└── pubspec.yaml
```
