import 'package:flutter/material.dart';
import '../models/price_breakdown.dart';
import '../models/size_line.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/formatters.dart';

/// Collapsible card showing every step of the price (cut lengths included),
/// so it can be checked against the Excel sheet.
class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({super.key, required this.breakdown});

  final PriceBreakdown breakdown;

  String _rs(double v) => formatRs(v.round());

  @override
  Widget build(BuildContext context) {
    final b = breakdown;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          shape: const Border(),
          collapsedShape: const Border(),
          title: Text(
            'Price details',
            style: bodyStyle(16, weight: FontWeight.w600),
          ),
          subtitle: Text(
            'Cut lengths and cost of each part',
            style: bodyStyle(13, color: AppColors.muted),
          ),
          children: [
            for (final p in b.profiles)
              _Line(
                '${p.code} · ${SizeLine.formatFt(p.lengthFt)} ft × ${SizeLine.formatFt(p.ratePerFt)}',
                _rs(p.cost),
              ),
            const _Rule(),
            _Line('Aluminium', _rs(b.aluminium)),
            _Line(
              'Discount ${SizeLine.formatFt(b.discountPercent)}%',
              '− ${_rs(b.discount)}',
            ),
            _Line('Hardware', _rs(b.hardware)),
            _Line('Glass', _rs(b.glass)),
            _Line('Labour', _rs(b.labour)),
            _Line('Rent', _rs(b.rent)),
            const _Rule(),
            _Line('Total', _rs(b.total), strong: true),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = bodyStyle(
      strong ? 16 : 14,
      weight: strong ? FontWeight.w600 : FontWeight.w400,
      color: strong ? AppColors.ink : AppColors.muted,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style.copyWith(color: AppColors.ink)),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Divider(height: 1, color: Color(0xFFE3E8EC)),
    );
  }
}