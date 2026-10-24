import 'package:flutter/material.dart';
import '../models/frame_color.dart';
import '../models/opening.dart';
import '../models/price_breakdown.dart';
import '../models/rates.dart';
import '../models/size_line.dart';
import '../services/price_calculator.dart';
import '../services/rates_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/add_opening_button.dart';
import '../widgets/color_selector.dart';
import '../widgets/discount_row.dart';
import '../widgets/opening_preview.dart';
import '../widgets/opening_type_selector.dart';
import '../widgets/price_breakdown_cards.dart';
import '../widgets/quotation_bottom_bar.dart';
import '../widgets/size_row_tile.dart';
import '../widgets/square_icon_button.dart';

/// Returns an [Opening] through Navigator.pop when the user taps Save.
class OpeningBuilderScreen extends StatefulWidget {
  const OpeningBuilderScreen({
    super.key,
    this.initial,
    this.quotationNumber = 'Q-0024',
  });

  /// Pass an existing opening to edit it.
  final Opening? initial;
  final String quotationNumber;

  @override
  State<OpeningBuilderScreen> createState() => _OpeningBuilderScreenState();
}

class _RowData {
  _RowData({double width = 4, double height = 4, this.quantity = 1})
      : width = TextEditingController(text: SizeLine.formatFt(width)),
        height = TextEditingController(text: SizeLine.formatFt(height));

  final TextEditingController width;
  final TextEditingController height;
  int quantity;

  SizeLine toSizeLine() => SizeLine(
    widthFt: double.tryParse(width.text) ?? 0,
    heightFt: double.tryParse(height.text) ?? 0,
    quantity: quantity,
  );

  void dispose() {
    width.dispose();
    height.dispose();
  }
}

class _OpeningBuilderScreenState extends State<OpeningBuilderScreen> {
  late OpeningType _type;
  late String _color;
  GroupRates? _rates;

  final _discountController = TextEditingController();
  bool _discountTouched = false;

  final List<_RowData> _rows = [];
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    final o = widget.initial;
    if (o == null) {
      _type = OpeningType.cSectionWindow;
      _color = FrameColor.options.first.name;
      _rows.add(_RowData());
    } else {
      _type = o.type;
      _color = o.color;
      _discountController.text = SizeLine.formatFt(o.discountPercent);
      _discountTouched = true;
      for (final s in o.sizes) {
        _rows.add(_RowData(
          width: s.widthFt,
          height: s.heightFt,
          quantity: s.quantity,
        ));
      }
    }
    _loadRates();
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _loadRates() async {
    final group = _type.rateGroup;
    final rates = await RatesService.instance.load(group);
    if (!mounted || group != _type.rateGroup) return;
    setState(() {
      _rates = rates;
      if (!_discountTouched) {
        _discountController.text =
            SizeLine.formatFt(rates.defaultDiscountPercent);
      }
    });
  }

  // ---- values worked out from the fields ----

  List<SizeLine> get _sizes => _rows.map((r) => r.toSizeLine()).toList();

  int get _pieces => _sizes.fold(0, (sum, s) => sum + s.quantity);

  double get _area => _sizes.fold(0.0, (sum, s) => sum + s.totalAreaSqFt);

  double get _discount =>
      (double.tryParse(_discountController.text) ?? 0).clamp(0, 100).toDouble();

  PriceBreakdown? get _breakdown {
    final rates = _rates;
    if (rates == null) return null;
    return PriceCalculator.calculate(
      type: _type,
      sizes: _sizes,
      rates: rates,
      discountPercent: _discount,
    );
  }

  bool get _sizesValid => _sizes.every(
        (s) => s.widthFt > 0 && s.heightFt > 0 && s.quantity > 0,
  );

  // ---- actions ----

  void _addRow() {
    final last = _rows.last.toSizeLine();
    setState(() {
      _rows.add(_RowData(width: last.widthFt, height: last.heightFt));
      _selected = _rows.length - 1;
    });
  }

  void _removeRow(int i) {
    setState(() {
      _rows.removeAt(i).dispose();
      if (i < _selected) _selected--;
      if (_selected >= _rows.length) _selected = _rows.length - 1;
    });
  }

  void _save() {
    final breakdown = _breakdown;
    if (breakdown == null) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(
      Opening(
        type: _type,
        color: _color,
        glass: _rates?.glass.code ?? 'Glass 5 mm',
        sizes: _sizes,
        discountPercent: _discount,
        price: breakdown.total.round(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakdown = _breakdown;
    final selectedSize = _rows[_selected].toSizeLine();
    final pieces = _pieces;
    final missingRates =
        breakdown != null && breakdown.profiles.any((p) => p.ratePerFt == 0);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    SquareIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.initial == null ? 'Add opening' : 'Edit opening',
                            style: displayStyle(26),
                          ),
                          Text(
                            'Quotation ${widget.quotationNumber}',
                            style: bodyStyle(13, color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    OpeningTypeSelector(
                      selected: _type,
                      onChanged: (t) {
                        setState(() => _type = t);
                        _loadRates();
                      },
                    ),
                    const SizedBox(height: 14),
                    OpeningPreview(
                      type: _type,
                      widthFt: selectedSize.widthFt,
                      heightFt: selectedSize.heightFt,
                      frameColor: FrameColor.colorOf(_color),
                      caption: 'Size ${_selected + 1} of ${_rows.length}',
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sizes', style: displayStyle(22)),
                        Text(
                          '${_rows.length} ${_rows.length == 1 ? 'size' : 'sizes'} · $pieces ${pieces == 1 ? 'piece' : 'pieces'}',
                          style: bodyStyle(14, color: AppColors.muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < _rows.length; i++) ...[
                      SizeRowTile(
                        widthController: _rows[i].width,
                        heightController: _rows[i].height,
                        quantity: _rows[i].quantity,
                        selected: i == _selected,
                        onSelect: () => setState(() => _selected = i),
                        onChanged: () => setState(() {}),
                        onQuantityChanged: (q) =>
                            setState(() => _rows[i].quantity = q),
                        onRemove: _rows.length > 1 ? () => _removeRow(i) : null,
                      ),
                      const SizedBox(height: 8),
                    ],
                    AddOpeningButton(
                      label: 'Add size',
                      height: 44,
                      onPressed: _addRow,
                    ),
                    const SizedBox(height: 14),
                    ColorSelector(
                      selected: _color,
                      onChanged: (c) => setState(() => _color = c),
                    ),
                    const SizedBox(height: 10),
                    DiscountRow(
                      controller: _discountController,
                      onChanged: () => setState(() => _discountTouched = true),
                    ),
                    const SizedBox(height: 14),
                    if (missingRates) ...[
                      const _Notice(
                        'Some profile prices are 0. Enter your prices '
                            'in the Rates tab.',
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (breakdown != null)
                      PriceBreakdownCard(breakdown: breakdown),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: QuotationBottomBar(
        total: breakdown?.total.round() ?? 0,
        caption:
        '${SizeLine.formatFt(_area)} sq ft · $pieces ${pieces == 1 ? 'pc' : 'pcs'}',
        actionLabel: 'Save opening',
        enabled: breakdown != null && _sizesValid,
        onAction: _save,
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE7D6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 20, color: AppColors.accentDark),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: bodyStyle(14, color: AppColors.accentDark),
            ),
          ),
        ],
      ),
    );
  }
}