import '../models/rates.dart';

/// Holds the rates. For now they live in memory only.
///
/// TODO: replace the body of [load] and [save] with SQLite (Drift).
/// Keep the method signatures the same so no screen needs to change.
class RatesService {
  RatesService._();
  static final RatesService instance = RatesService._();

  final Map<RateGroup, GroupRates> _data = {
    RateGroup.windows: const GroupRates(
      profiles: [
        RateItem(code: 'DC26C', price: 0),
        RateItem(code: 'DC30C', price: 0),
        RateItem(code: 'M23', price: 0),
        RateItem(code: 'M28', price: 0),
        RateItem(code: 'M24', price: 0),
        RateItem(code: 'D29', price: 0),
      ],
      glass: RateItem(code: 'Glass 5 mm', price: 0),
    ),
    RateGroup.fSection: const GroupRates(
      profiles: [
        RateItem(code: 'DC26F', price: 0),
        RateItem(code: 'DC30F', price: 0),
        RateItem(code: 'M23', price: 0),
        RateItem(code: 'M28', price: 0),
        RateItem(code: 'M24', price: 0),
        RateItem(code: 'D29', price: 0),
      ],
      glass: RateItem(code: 'Glass 5 mm', price: 0),
    ),
    RateGroup.mSection: const GroupRates(
      profiles: [
        RateItem(code: 'M26', price: 0),
        RateItem(code: 'M30', price: 0),
        RateItem(code: 'M23', price: 0),
        RateItem(code: 'M28', price: 0),
        RateItem(code: 'M24', price: 0),
      ],
      glass: RateItem(code: 'Glass 5 mm', price: 0),
    ),
    RateGroup.mfSection: const GroupRates(
      profiles: [
        RateItem(code: 'M26F', price: 0),
        RateItem(code: 'M30F', price: 0),
        RateItem(code: 'M23', price: 0),
        RateItem(code: 'M28', price: 0),
        RateItem(code: 'M24', price: 0),
      ],
      glass: RateItem(code: 'Glass 5 mm', price: 0),
    ),
  };

  Future<GroupRates> load(RateGroup group) async => _data[group]!;

  Future<void> save(RateGroup group, GroupRates rates) async {
    _data[group] = rates;
  }
}