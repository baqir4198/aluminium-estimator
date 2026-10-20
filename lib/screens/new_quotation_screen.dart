import 'package:flutter/material.dart';
import 'package:aluminium_estimator/models/opening.dart';
import 'package:aluminium_estimator/theme/app_colors.dart';
import 'package:aluminium_estimator/theme/app_text.dart';
import 'package:aluminium_estimator/widgets/add_opening_button.dart';
import 'package:aluminium_estimator/widgets/customer_card.dart';
import 'package:aluminium_estimator/widgets/opening_tile.dart';
import 'package:aluminium_estimator/widgets/quotation_bottom_bar.dart';
import 'package:aluminium_estimator/widgets/square_icon_button.dart';

class NewQuotationScreen extends StatefulWidget {
  const NewQuotationScreen({super.key});

  @override
  State<NewQuotationScreen> createState() => _NewQuotationScreenState();
}

class _NewQuotationScreenState extends State<NewQuotationScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Sample data. Start with an empty list once the opening builder exists.
  final List<Opening> _openings = [
    const Opening(
      type: OpeningType.slidingWindow,
      widthFt: 4,
      heightFt: 4,
      quantity: 2,
      color: 'Silver',
      price: 32000,
    ),
    const Opening(
      type: OpeningType.fixedGlass,
      widthFt: 3,
      heightFt: 5,
      quantity: 1,
      color: 'Bronze',
      price: 9500,
    ),
    const Opening(
      type: OpeningType.door,
      widthFt: 3,
      heightFt: 7,
      quantity: 1,
      color: 'Black',
      price: 24500,
    ),
  ];

  int get _total => _openings.fold(0, (sum, o) => sum + o.price);
  int get _pieces => _openings.fold(0, (sum, o) => sum + o.quantity);

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

  void _addOpening() {
    // TODO: push the Opening Builder screen and add the returned Opening.
  }

  void _editOpening(int index) {
    // TODO: open the Opening Builder with this opening.
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
        pieces: _pieces,
        onPreview: () {},
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