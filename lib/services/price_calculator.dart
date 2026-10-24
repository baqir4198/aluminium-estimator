import '../models/opening.dart';
import '../models/price_breakdown.dart';
import '../models/rates.dart';
import '../models/size_line.dart';

/// Works out the price of an opening from its sizes and the saved rates
/// (1.2 mm profile prices).
///
/// All sizes are in feet. Every length is worked out for one window and
/// multiplied by the quantity, so 2 windows always give double the lengths
/// of 1 window.
///
/// Lengths per window (W = width, H = height):
///   bottom profile (DC26C / DC26F) : W + bottomExtra      (0 or 0.5 ft)
///   top profile    (DC30C / DC30F) : W + 2H + topExtra     (0 or 1 ft)
///   D29                            : W + 2H
///   M23 and M28                    : 2H each
///   M24                            : 2W
class PriceCalculator {
  PriceCalculator._();

  static PriceBreakdown calculate({
    required OpeningType type,
    required List<SizeLine> sizes,
    required GroupRates rates,
    required double discountPercent,
  }) {
    double bottom = 0, top = 0, d29 = 0, m23 = 0, m28 = 0, m24 = 0;
    double area = 0;
    int pieces = 0;

    for (final s in sizes) {
      final w = s.widthFt;
      final h = s.heightFt;
      final q = s.quantity;

      bottom += (w + type.bottomExtraFt) * q; // bottom width
      top += (w + 2 * h + type.topExtraFt) * q; // top width + two heights
      d29 += (w + 2 * h) * q; // same three sides, no extra
      m23 += 2 * h * q; // two heights
      m28 += 2 * h * q; // two heights
      m24 += 2 * w * q; // two widths

      area += w * h * q;
      pieces += q;
    }

    double rateOf(String code) {
      for (final p in rates.profiles) {
        if (p.code == code) return p.price;
      }
      return 0;
    }

    ProfileCost profile(String code, double length) =>
        ProfileCost(code: code, lengthFt: length, ratePerFt: rateOf(code));

    return PriceBreakdown(
      profiles: [
        profile(type.bottomProfile, bottom),
        profile(type.topProfile, top),
        profile('M23', m23),
        profile('M28', m28),
        profile('M24', m24),
        profile('D29', d29),
      ],
      discountPercent: discountPercent.clamp(0, 100).toDouble(),
      hardware: rates.hardwarePerWindow * pieces,
      glass: rates.glass.price * area,
      labour: rates.labourPerSqFt * area,
      rent: rates.rentPerWindow * pieces,
      areaSqFt: area,
      pieces: pieces,
    );
  }
}