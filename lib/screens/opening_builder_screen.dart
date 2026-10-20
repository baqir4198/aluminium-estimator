import 'package:flutter/material.dart';
import '../models/frame_color.dart';
import '../models/opening.dart';
import '../models/size_line.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/add_opening_button.dart';
import '../widgets/color_selector.dart';
import '../widgets/opening_preview.dart';
import '../widgets/opening_type_selector.dart';
import '../widgets/option_row.dart';
import '../widgets/quotation_bottom_bar.dart';
import '../widgets/square_icon_button.dart';
import '../widgets/size_row_tile.dart';

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
  // TODO: load these from the Rates screen / database later.
  static const _defaultRate = 1000;
  static const _glassOptions = [
    '5 mm clear',
    '5 mm tinted',
    '6 mm clear',
    '6 mm tinted',
    'Frosted',
  ];

  late OpeningType _type;
  late String _color;
  late String _glass;
  late int _rate;
  final List<_RowData> _rows = [];
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    final o = widget.initial;
    if (o == null) {
      _type = OpeningType.slidingWindow;
      _color = FrameColor.options.first.name;
      _glass = _glassOptions.first;
      _rate = _defaultRate;
      _rows.add(_RowData());
    } else {
      _type = o.type;
      _color = o.color;
      _glass = o.glass;
      _rate = o.ratePerSqFt;
      for (final s in o.sizes) {
        _rows.add(_RowData(
          width: s.widthFt,
          height: s.heightFt,
          quantity: s.quantity,
        ));
      }
    }
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  List<SizeLine> get _sizes => _rows.map((r) => r.toSizeLine()).toList();

  Opening get _draft => Opening(
    type: _type,
    color: _color,
    glass: _glass,
    sizes: _sizes,
    ratePerSqFt: _rate,
  );

  bool get _valid => _sizes.every(
        (s) => s.widthFt > 0 && s.heightFt > 0 && s.quantity > 0,
  );

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

  Future<void> _pickGlass() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final g in _glassOptions)
              ListTile(
                title: Text(g, style: bodyStyle(16)),
                trailing: g == _glass
                    ? const Icon(Icons.check_rounded, color: AppColors.accent)
                    : null,
                onTap: () => Navigator.of(context).pop(g),
              ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _glass = picked);
  }

  void _save() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(_draft);
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;
    final selectedSize = _rows[_selected].toSizeLine();
    final area = SizeLine.formatFt(draft.totalAreaSqFt);

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
                      onChanged: (t) => setState(() => _type = t),
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
                          '${_rows.length} ${_rows.length == 1 ? 'size' : 'sizes'} · ${draft.pieces} ${draft.pieces == 1 ? 'piece' : 'pieces'}',
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
                    OptionRow(label: 'Glass', value: _glass, onTap: _pickGlass),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: QuotationBottomBar(
        total: draft.price,
        caption: '$area sq ft · ${draft.pieces} ${draft.pieces == 1 ? 'pc' : 'pcs'}',
        actionLabel: 'Save opening',
        enabled: _valid,
        onAction: _save,
      ),
    );
  }
}