/// Paw reward animation widgets for VUIHOC.
///
/// Cung cấp các widget animation thuần Flutter để hiển thị hiệu ứng
/// nhận thưởng chân mèo (paw reward), bao gồm confetti, sparkles,
/// paw flights, glow ring, count-up text, v.v.
library;

// Enums
export 'src/enums/paw_enums.dart';

// Colors
export 'src/colors/paw_colors.dart';

// Utils
export 'src/utils/paw_format.dart';
export 'src/utils/animation_extension.dart';

// Models
export 'src/models/confetti_data.dart';
export 'src/models/paw_flight_data.dart';
export 'src/models/sparkle_data.dart';

// Configs
export 'src/configs/reward_animation_configs.dart';

// Widgets — Common
export 'src/widgets/common/big_paw.dart';
export 'src/widgets/common/mini_paw.dart';
export 'src/widgets/common/flight_particles.dart';
export 'src/widgets/common/confetti_painter.dart';
export 'src/widgets/common/count_up_text.dart';
export 'src/widgets/common/glow_ring.dart';
export 'src/widgets/common/design_badge.dart';
export 'src/widgets/common/paw_reward_controller.dart';
export 'src/widgets/common/paw_reward_screen.dart';
export 'src/widgets/common/paw_common_claim_reward.dart';

// Widgets — Simulator overlays
export 'src/widgets/simulator/sparkles_overlay.dart';
export 'src/widgets/simulator/confetti_overlay.dart';
export 'src/widgets/simulator/floating_text_overlay.dart';
export 'src/widgets/simulator/paw_flights_overlay.dart';
export 'src/widgets/simulator/reward_badge_overlay.dart';
export 'src/widgets/simulator/effects_overlay.dart';
export 'src/widgets/simulator/simulator_reward_controller.dart';
export 'src/widgets/simulator/paw_simulator_claim_reward.dart';
export 'src/widgets/simulator/paw_simulator_reward_result_screen.dart';
