# paw_anim example

App chạy thử ba widget nhận thưởng của package `paw_anim`, dùng dependency local `path: ../`.
Mascot và bảng kết quả dùng widget Flutter có sẵn, không cần thêm assets.

## Chạy example

Yêu cầu Flutter với Dart >= 3.10.0.

```sh
cd example
flutter pub get
flutter run
```

Chọn thiết bị Android/iOS đã kết nối hoặc emulator/simulator. Để chạy trên Chrome:

```sh
flutter run -d chrome
```

Nếu chạy trên iPhone thật, chọn Development Team của bạn trong Xcode.

## Các màn hình demo

- `PawCommonClaimReward`: popup tự đóng khi hiệu ứng hoàn tất.
- `PawSimulatorClaimReward`: màn hình trao thưởng tự đóng khi hoàn tất.
- `PawSimulatorRewardResultScreen`: màn hình kết quả; bấm nút đóng ở góc trái để quay lại.

Mỗi lần bấm nút sẽ tạo hiệu ứng mới. Chỉnh `awardedPoints` và `finalBalance` trong `lib/main.dart` để thử dữ liệu khác.
