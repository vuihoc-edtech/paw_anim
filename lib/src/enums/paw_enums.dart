// Các enum dùng cho animation paw reward.

/// Các trạng thái/giai đoạn của màn hình nhận thưởng.
enum RewardPhase { init, fly, flash, done }

/// Loại Widget animation.
/// - [simulatorExercise]: Màn hoàn thành bài tập mô phỏng
/// - [simulator]: Màn hoàn thành câu hỏi trắc nghiệm mô phỏng (Hiển thị cúp)
/// - [common]: Các màn khác dùng (Celebration Reward)
enum LoyaltyWidgetType { common, simulator, simulatorExercise }
