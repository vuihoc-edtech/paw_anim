/// Định dạng số điểm paw theo kiểu rút gọn (1k, 1.5M, ...).
extension PawFormatExt on int? {
  String toPawFormat() {
    if (this == null) return '0';
    final int value = this!;

    if (value < 1000) return value.toString();

    String fmt(num n) {
      final truncated = (n * 10).floor() / 10;
      final s = truncated.toStringAsFixed(1);
      return s.replaceAll(RegExp(r'\.0$'), '');
    }

    if (value <= 99999) return '${fmt(value / 1000)}k';
    if (value <= 999999) return '${(value / 1000).floor()}k';
    if (value <= 99999999) return '${fmt(value / 1000000)}M';
    if (value <= 999999999) return '${(value / 1000000).floor()}M';
    return '${fmt(value / 1000000000)}B';
  }
}
