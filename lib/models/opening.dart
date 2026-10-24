import 'rates.dart';
import 'size_line.dart';

enum OpeningType {
  /// No outer border layer, so no extra length on the two profiles.
  cSectionWindow(
    'C-Section Window',
    'C-Section Window',
    RateGroup.windows,
    bottomProfile: 'DC26C',
    topProfile: 'DC30C',
    bottomExtraFt: 0,
    topExtraFt: 0,
  ),

  /// Outer border layer: half a foot extra on the bottom profile and
  /// one foot extra on the top profile, for every window of any size.
  fSectionWindow(
    'F-Section Window',
    'F-Section Window',
    RateGroup.fSection,
    bottomProfile: 'DC26F',
    topProfile: 'DC30F',
    bottomExtraFt: 0.5,
    topExtraFt: 1,
  );

  const OpeningType(
      this.label,
      this.shortLabel,
      this.rateGroup, {
        required this.bottomProfile,
        required this.topProfile,
        required this.bottomExtraFt,
        required this.topExtraFt,
      });

  final String label;
  final String shortLabel;

  /// Which Rates tab supplies the prices for this type.
  final RateGroup rateGroup;

  /// Profile that runs along the bottom width (width + [bottomExtraFt]).
  final String bottomProfile;

  /// Profile that runs along the top width and both side heights
  /// (width + 2 x height + [topExtraFt]).
  final String topProfile;

  final double bottomExtraFt;
  final double topExtraFt;
}

/// One kind of window (type, color) in one or more sizes.
class Opening {
  const Opening({
    required this.type,
    required this.color,
    required this.glass,
    required this.sizes,
    required this.discountPercent,
    required this.price,
  });

  final OpeningType type;
  final String color;
  final String glass;
  final List<SizeLine> sizes;

  /// Discount on the aluminium only, in percent.
  final double discountPercent;

  /// Final price, saved when the opening was saved. Later changes in Rates
  /// do not change the price of an opening that is already in a quotation.
  final int price;

  int get pieces => sizes.fold(0, (sum, s) => sum + s.quantity);

  double get totalAreaSqFt =>
      sizes.fold(0.0, (sum, s) => sum + s.totalAreaSqFt);

  String get sizesSummary {
    if (sizes.length == 1) {
      final s = sizes.first;
      return '${s.label} · Qty ${s.quantity}';
    }
    return '${sizes.length} sizes · $pieces ${pieces == 1 ? 'piece' : 'pieces'}';
  }
}