class ProfileCost {
  const ProfileCost({
    required this.code,
    required this.lengthFt,
    required this.ratePerFt,
  });

  final String code;
  final double lengthFt;
  final double ratePerFt;

  double get cost => lengthFt * ratePerFt;
}

/// Every step of a price, so it can be shown and checked.
class PriceBreakdown {
  const PriceBreakdown({
    required this.profiles,
    required this.discountPercent,
    required this.hardware,
    required this.glass,
    required this.labour,
    required this.rent,
    required this.areaSqFt,
    required this.pieces,
  });

  final List<ProfileCost> profiles;
  final double discountPercent;
  final double hardware;
  final double glass;
  final double labour;
  final double rent;
  final double areaSqFt;
  final int pieces;

  double get aluminium => profiles.fold(0.0, (sum, p) => sum + p.cost);
  double get discount => aluminium * discountPercent / 100;
  double get aluminiumAfterDiscount => aluminium - discount;

  /// Discounted aluminium + hardware + glass + labour + rent.
  double get total => aluminiumAfterDiscount + hardware + glass + labour + rent;
}