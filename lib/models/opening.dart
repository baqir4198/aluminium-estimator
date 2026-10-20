enum OpeningType {
  slidingWindow('2-track sliding window'),
  fixedGlass('Fixed glass'),
  door('Door');

  const OpeningType(this.label);
  final String label;
}

class Opening {
  const Opening({
    required this.type,
    required this.widthFt,
    required this.heightFt,
    required this.quantity,
    required this.color,
    required this.price,
  });

  final OpeningType type;
  final double widthFt;
  final double heightFt;
  final int quantity;
  final String color;

  /// Line total for this opening (quantity already included).
  final int price;

  String get sizeLabel => "${_ft(widthFt)}' × ${_ft(heightFt)}'";

  static String _ft(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}