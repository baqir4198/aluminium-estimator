import 'rates.dart';
import 'size_line.dart';

enum OpeningType {
  /// No outer border layer, so no extra length on the two profiles.
  cSectionWindow(
    'C-Section Window',
    'C-Section',
    RateGroup.windows,
    bottomProfile: 'DC26C',
    topProfile: 'DC30C',
    bottomExtraFt: 0,
    topExtraFt: 0,
    hasMeshPanel: true,
  ),

  /// Outer border layer: half a foot extra on the bottom profile and
  /// one foot extra on the top profile, for every window of any size.
  fSectionWindow(
    'F-Section Window',
    'F-Section',
    RateGroup.fSection,
    bottomProfile: 'DC26F',
    topProfile: 'DC30F',
    bottomExtraFt: 0.5,
    topExtraFt: 1,
    hasMeshPanel: true,
  ),

  /// Like the C-Section window, but with M26 and M30 instead of DC26C and
  /// DC30C, and no mesh panel (so no D29).
  mSectionWindow(
    'M-Section Window',
    'M-Section',
    RateGroup.mSection,
    bottomProfile: 'M26',
    topProfile: 'M30',
    bottomExtraFt: 0,
    topExtraFt: 0,
    hasMeshPanel: false,
  ),

  /// Like the M-Section window, plus the outer border layer. It uses M26F
  /// and M30F, with half a foot extra on M26F and one foot extra on M30F,
  /// for every window of any size.
  mfSectionWindow(
    'MF-Section Window',
    'MF-Section',
    RateGroup.mfSection,
    bottomProfile: 'M26F',
    topProfile: 'M30F',
    bottomExtraFt: 0.5,
    topExtraFt: 1,
    hasMeshPanel: false,
  );

  const OpeningType(
      this.label,
      this.shortLabel,
      this.rateGroup, {
        required this.bottomProfile,
        required this.topProfile,
        required this.bottomExtraFt,
        required this.topExtraFt,
        required this.hasMeshPanel,
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

  /// The mesh panel uses D29 (width + 2 x height). Without it, no D29.
  final bool hasMeshPanel;
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