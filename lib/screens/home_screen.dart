import 'package:flutter/material.dart';
import '../models/job.dart';
import '../theme/app_space.dart';
import '../widgets/home_header.dart';
import '../widgets/job_tile.dart';
import '../widgets/new_quotation_button.dart';
import '../widgets/pending_payments_card.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_tile.dart';
import 'new_quotation_screen.dart';

/// Home tab. The bottom navigation now lives in MainShell.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  void _openNewQuotation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NewQuotationScreen()),
    );
  }

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
                  const HomeHeader(),
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
                  NewQuotationButton(onPressed: () => _openNewQuotation(context)),
                  const SizedBox(height: AppSpace.xl),
                  SectionHeader(
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
    );
  }
}