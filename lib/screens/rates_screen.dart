import 'package:flutter/material.dart';
import '../models/rates.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/pill_tabs.dart';
import '../widgets/rate_group_view.dart';

class RatesScreen extends StatefulWidget {
  const RatesScreen({super.key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  RateGroup _group = RateGroup.windows;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rates', style: displayStyle(30)),
                  Text(
                    'Enter the price once. Quotations use it automatically.',
                    style: bodyStyle(14, color: AppColors.muted),
                  ),
                  const SizedBox(height: 14),
                  PillTabs<RateGroup>(
                    items: RateGroup.values,
                    labelOf: (g) => g.label,
                    selected: _group,
                    onChanged: (g) => setState(() => _group = g),
                  ),
                ],
              ),
            ),
            Expanded(
              // The key makes Flutter rebuild the list for each group.
              child: RateGroupView(key: ValueKey(_group), group: _group),
            ),
          ],
        ),
      ),
    );
  }
}