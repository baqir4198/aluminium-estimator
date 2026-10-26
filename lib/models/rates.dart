enum RateGroup {
  windows('Windows'),
  fSection('F-Section'),
  mSection('M-Section'),
  mfSection('MF-Section');

  const RateGroup(this.label);
  final String label;
}

/// One price: a profile (per foot) or glass (per sq ft).
class RateItem {
  const RateItem({
    required this.code,
    required this.price,
    this.isCustom = false,
  });

  final String code;
  final double price;

  /// True for profiles the user added with "+ Add profile".
  /// Only custom profiles can be deleted.
  final bool isCustom;

  RateItem copyWith({String? code, double? price, bool? isCustom}) => RateItem(
    code: code ?? this.code,
    price: price ?? this.price,
    isCustom: isCustom ?? this.isCustom,
  );
}

/// All prices of one group (Windows or F-Section).
/// Profile prices are the 1.2 mm rates (per foot).
class GroupRates {
  const GroupRates({
    required this.profiles,
    required this.glass,
    this.hardwarePerWindow = 0,
    this.labourPerSqFt = 0,
    this.rentPerWindow = 0,
    this.defaultDiscountPercent = 10,
  });

  final List<RateItem> profiles;
  final RateItem glass;

  /// Fixed amount for every window.
  final double hardwarePerWindow;

  /// Amount per sq ft of window area.
  final double labourPerSqFt;

  /// Fixed amount for every window.
  final double rentPerWindow;

  /// Starting value of the discount field on the Add opening screen.
  /// The discount is applied to the aluminium (profiles) only.
  final double defaultDiscountPercent;
}