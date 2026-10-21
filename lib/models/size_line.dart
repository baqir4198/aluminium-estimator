class SizeLine {
  const SizeLine({
    required this.widthFt,
    required this.heightFt,
    required this.quantity,
  });

  final double widthFt;
  final double heightFt;
  final int quantity;

  double get areaSqFt => widthFt * heightFt;
  double get totalAreaSqFt => areaSqFt * quantity;

  String get label => "${formatFt(widthFt)}' × ${formatFt(heightFt)}'";

  /// 4.0 -> "4", 4.5 -> "4.5", 4.1000000001 -> "4.1"
  static String formatFt(double v) {
    final r = double.parse(v.toStringAsFixed(2));
    return r == r.roundToDouble() ? r.toInt().toString() : r.toString();
  }
}