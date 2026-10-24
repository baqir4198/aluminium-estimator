import 'package:flutter/material.dart';
import '../models/rates.dart';
import '../services/rates_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'rate_field_row.dart';

/// Profile prices, glass price and other charges for one group.
/// Every change is saved straight away through [RatesService].
class RateGroupView extends StatefulWidget {
  const RateGroupView({super.key, required this.group});

  final RateGroup group;

  @override
  State<RateGroupView> createState() => _RateGroupViewState();
}

String _formatNumber(double v) {
  if (v == 0) return '';
  return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}

class _RateRow {
  _RateRow(this.code, double price, {this.isCustom = false})
      : controller = TextEditingController(text: _formatNumber(price));

  final String code;
  final bool isCustom;
  final TextEditingController controller;

  double get price => double.tryParse(controller.text) ?? 0;

  void dispose() => controller.dispose();
}

class _RateGroupViewState extends State<RateGroupView> {
  final _service = RatesService.instance;
  final List<_RateRow> _profiles = [];
  _RateRow? _glass;

  final _hardware = TextEditingController();
  final _labour = TextEditingController();
  final _rent = TextEditingController();
  final _discount = TextEditingController();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final p in _profiles) {
      p.dispose();
    }
    _glass?.dispose();
    _hardware.dispose();
    _labour.dispose();
    _rent.dispose();
    _discount.dispose();
    super.dispose();
  }

  double _read(TextEditingController c) => double.tryParse(c.text) ?? 0;

  Future<void> _load() async {
    final data = await _service.load(widget.group);
    if (!mounted) return;
    setState(() {
      for (final p in data.profiles) {
        _profiles.add(_RateRow(p.code, p.price, isCustom: p.isCustom));
      }
      _glass = _RateRow(data.glass.code, data.glass.price);
      _hardware.text = _formatNumber(data.hardwarePerWindow);
      _labour.text = _formatNumber(data.labourPerSqFt);
      _rent.text = _formatNumber(data.rentPerWindow);
      _discount.text = _formatNumber(data.defaultDiscountPercent);
      _loading = false;
    });
  }

  void _save() {
    final glass = _glass;
    if (glass == null) return;
    _service.save(
      widget.group,
      GroupRates(
        profiles: [
          for (final p in _profiles)
            RateItem(code: p.code, price: p.price, isCustom: p.isCustom),
        ],
        glass: RateItem(code: glass.code, price: glass.price),
        hardwarePerWindow: _read(_hardware),
        labourPerSqFt: _read(_labour),
        rentPerWindow: _read(_rent),
        defaultDiscountPercent: _read(_discount),
      ),
    );
  }

  Future<void> _addProfile() async {
    final code = await showDialog<String>(
      context: context,
      builder: (_) => const _AddProfileDialog(),
    );
    if (code == null || !mounted) return;

    final exists =
    _profiles.any((p) => p.code.toLowerCase() == code.toLowerCase());
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$code is already in the list')),
      );
      return;
    }
    setState(() => _profiles.add(_RateRow(code, 0, isCustom: true)));
    _save();
  }

  void _deleteProfile(int index) {
    final removed = _profiles[index];
    FocusScope.of(context).unfocus();
    setState(() => _profiles.removeAt(index));
    _save();

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger
        .showSnackBar(
      SnackBar(
        content: Text('${removed.code} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (!mounted) return;
            setState(() {
              _profiles.insert(
                index.clamp(0, _profiles.length),
                removed,
              );
            });
            _save();
          },
        ),
      ),
    )
        .closed
        .then((reason) {
      // Free the controller only if the profile was really deleted.
      if (reason != SnackBarClosedReason.action) removed.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profiles (1.2 mm)', style: displayStyle(20)),
              TextButton(
                onPressed: _addProfile,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentDark,
                  minimumSize: const Size(48, 40),
                ),
                child: Text(
                  '+ Add profile',
                  style: bodyStyle(
                    14,
                    weight: FontWeight.w600,
                    color: AppColors.accentDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _Card(
            children: [
              for (var i = 0; i < _profiles.length; i++) ...[
                if (i > 0) const _Divider(),
                RateFieldRow(
                  label: _profiles[i].code,
                  controller: _profiles[i].controller,
                  suffix: '/ ft',
                  onChanged: _save,
                  onDelete: _profiles[i].isCustom
                      ? () => _deleteProfile(i)
                      : null,
                ),
              ],
            ],
          ),
          const SizedBox(height: 18),
          Text('Glass', style: displayStyle(20)),
          const SizedBox(height: 8),
          _Card(
            children: [
              RateFieldRow(
                label: _glass!.code,
                controller: _glass!.controller,
                suffix: '/ sq ft',
                onChanged: _save,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Other charges', style: displayStyle(20)),
          const SizedBox(height: 8),
          _Card(
            children: [
              RateFieldRow(
                label: 'Hardware',
                controller: _hardware,
                suffix: '/ window',
                onChanged: _save,
              ),
              const _Divider(),
              RateFieldRow(
                label: 'Labour',
                controller: _labour,
                suffix: '/ sq ft',
                onChanged: _save,
              ),
              const _Divider(),
              RateFieldRow(
                label: 'Rent',
                controller: _rent,
                suffix: '/ window',
                onChanged: _save,
              ),
              const _Divider(),
              RateFieldRow(
                label: 'Default discount',
                controller: _discount,
                prefix: '',
                suffix: '%',
                onChanged: _save,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Text(
              'The discount applies to the aluminium only. '
                  'You can change it for each opening.',
              style: bodyStyle(13, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFE3E8EC),
    );
  }
}

class _AddProfileDialog extends StatefulWidget {
  const _AddProfileDialog();

  @override
  State<_AddProfileDialog> createState() => _AddProfileDialogState();
}

class _AddProfileDialogState extends State<_AddProfileDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) return;
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add profile'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(
          labelText: 'Profile name',
          hintText: 'For example M30',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}