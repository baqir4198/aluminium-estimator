enum RateGroup {
  windows('Windows'),
  fSection('F-Section');

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
class GroupRates {
  const GroupRates({required this.profiles, required this.glass});

  final List<RateItem> profiles;
  final RateItem glass;
}