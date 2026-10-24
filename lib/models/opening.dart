import 'rates.dart';
import 'size_line.dart';

enum OpeningType {
  cSectionWindow('C-Section Window', 'C-Section Window', RateGroup.windows),
  fSectionWindow('F-Section Window', 'F-Section Window', RateGroup.fSection);

  const OpeningType(this.label, this.shortLabel, this.rateGroup);
  final String label;
  final String shortLabel;

  /// Which Rates tab supplies the prices for this type.
  final RateGroup rateGroup;
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