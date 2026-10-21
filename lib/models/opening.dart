import 'size_line.dart';

enum OpeningType {
  slidingWindow('2-track sliding window', 'Sliding window'),
  fixedGlass('Fixed glass', 'Fixed glass'),
  door('Door', 'Door');

  const OpeningType(this.label, this.shortLabel);
  final String label;
  final String shortLabel;
}

/// One kind of window/door (type, color, glass) in one or more sizes.
class Opening {
  const Opening({
    required this.type,
    required this.color,
    required this.glass,
    required this.sizes,
    required this.ratePerSqFt,
  });

  final OpeningType type;
  final String color;
  final String glass;
  final List<SizeLine> sizes;
  final int ratePerSqFt;

  int get pieces => sizes.fold(0, (sum, s) => sum + s.quantity);

  double get totalAreaSqFt =>
      sizes.fold(0.0, (sum, s) => sum + s.totalAreaSqFt);

  int get price => (totalAreaSqFt * ratePerSqFt).round();

  String get sizesSummary {
    if (sizes.length == 1) {
      final s = sizes.first;
      return '${s.label} · Qty ${s.quantity}';
    }
    return '${sizes.length} sizes · $pieces ${pieces == 1 ? 'piece' : 'pieces'}';
  }
}