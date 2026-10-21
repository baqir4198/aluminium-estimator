import 'package:flutter/material.dart';
import '../models/opening.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/add_opening_button.dart';
import '../widgets/customer_card.dart';
import '../widgets/opening_tile.dart';
import '../widgets/quotation_bottom_bar.dart';
import '../widgets/square_icon_button.dart';
import 'opening_builder_screen.dart';

class NewQuotationScreen extends StatefulWidget {
  const NewQuotationScreen({super.key});

  @override
  State<NewQuotationScreen> createState() => _NewQuotationScreenState();
}

class _NewQuotationScreenState extends State<NewQuotationScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<Opening> _openings = [];

  int get _total => _openings.fold(0, (sum, o) => sum + o.price);
  int get _pieces => _openings.fold(0, (sum, o) => sum + o.pieces);

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _dateLabel {
    final d = DateTime.now();
    return '${d.day} ${_months[d.month - 1]} ${d.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _addOpening() async {
    final result = await Navigator.of(context).push<Opening>(
      MaterialPageRoute(builder: (_) => const OpeningBuilderScreen()),
    );
    if (result != null && mounted) {
      setState(() => _openings.add(result));
    }
  }

  Future<void> _editOpening(int index) async {
    final result = await Navigator.of(context).push<Opening>(
      MaterialPageRoute(
        builder: (_) => OpeningBuilderScreen(initial: _openings[index]),
      ),
    );
    if (result != null && mounted) {
      setState(() => _openings[index] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: _TopBar(dateLabel: _dateLabel),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    CustomerCard(
                      nameController: _nameController,
                      phoneController: _phoneController,
                      onPickContact: () {},
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Openings', style: displayStyle(22)),
                        Text(
                          '${_openings.length} ${_openings.length == 1 ? 'item' : 'items'}',
                          style: bodyStyle(14, color: AppColors.muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_openings.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No openings yet. Add your first window or door.',
                          textAlign: TextAlign.center,
                          style: bodyStyle(14, color: AppColors.muted),
                        ),
                      ),
                    for (var i = 0; i < _openings.length; i++) ...[
                      OpeningTile(
                        opening: _openings[i],
                        onTap: () => _editOpening(i),
                      ),
                      const SizedBox(height: 10),
                    ],
                    AddOpeningButton(onPressed: _addOpening),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: QuotationBottomBar(
        total: _total,
        caption:
        'Total · $_pieces ${_pieces == 1 ? 'piece' : 'pieces'}',
        actionLabel: 'Preview PDF',
        enabled: _pieces > 0,
        onAction: () {},
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.dateLabel});

  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              Text('New quotation', style: displayStyle(26)),
              Text(
                'Q-0024 · $dateLabel',
                style: bodyStyle(13, color: AppColors.muted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE3E8EE),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'Draft',
            style: bodyStyle(
              12,
              weight: FontWeight.w600,
              color: const Color(0xFF2F3A46),
            ),
          ),
        ),
      ],
    );
  }
}