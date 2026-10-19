
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/job.dart';
import '../theme/app_colors.dart';
import '../theme/app_space.dart';
import '../theme/app_text.dart';
import '../widgets/job_tile.dart';
import '../widgets/pending_payments_card.dart';
import '../widgets/stat_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  static const _jobs = [
    Job(
      customer: 'Customer name',
      summary: '6 windows · 2 doors',
      amount: 96000,
      status: JobStatus.quoted,
    ),
    Job(
      customer: 'Customer name',
      summary: '4 windows · 1 partition',
      amount: 58500,
      status: JobStatus.inFabrication,
    ),
    Job(
      customer: 'Customer name',
      summary: '3 doors',
      amount: 41000,
      status: JobStatus.installed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.xl,
                AppSpace.md,
                AppSpace.xl,
                0,
              ),
              sliver: SliverList.list(
                children: [
                  const _Header(),
                  const SizedBox(height: AppSpace.lg),
                  PendingPaymentsCard(
                    amount: 184500,
                    jobCount: 7,
                    onViewAll: () {},
                  ),
                  const SizedBox(height: AppSpace.md),
                  const Row(
                    children: [
                      Expanded(child: StatTile(value: '12', label: 'Active jobs')),
                      SizedBox(width: AppSpace.md),
                      Expanded(
                        child: StatTile(value: '9', label: 'Quotes this week'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.lg),
                  _NewQuotationButton(onPressed: () {}),
                  const SizedBox(height: AppSpace.xl),
                  _SectionHeader(
                    title: 'Recent jobs',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                  const SizedBox(height: AppSpace.sm),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.xl,
                0,
                AppSpace.xl,
                AppSpace.xxl,
              ),
              sliver: SliverList.separated(
                itemCount: _jobs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => JobTile(job: _jobs[i], onTap: () {}),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description_rounded),
            label: 'Quotes',
          ),
          NavigationDestination(
            icon: Icon(Icons.sell_outlined),
            selectedIcon: Icon(Icons.sell_rounded),
            label: 'Rates',
          ),
        ],
      ),
    );
  }
}

/* ------------------------------------------------------------------ */
/* Widgets                                                             */
/* ------------------------------------------------------------------ */

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning', style: bodyStyle(14, color: AppColors.muted)),
              Text('Workshop overview', style: displayStyle(30)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Search jobs and contacts',
          onPressed: () {},
          icon: const Icon(Icons.search_rounded),
          style: IconButton.styleFrom(
            fixedSize: const Size(48, 48),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.ink,
            side: const BorderSide(color: Color(0xFFCDD4DA)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}


class _NewQuotationButton extends StatelessWidget {
  const _NewQuotationButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded, size: 24),
      label: const Text('New quotation'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: bodyStyle(17, weight: FontWeight.w600),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: displayStyle(22)),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentDark,
            minimumSize: const Size(48, 48),
          ),
          child: Text(
            actionLabel,
            style: bodyStyle(
              14,
              weight: FontWeight.w600,
              color: AppColors.accentDark,
            ),
          ),
        ),
      ],
    );
  }
}

