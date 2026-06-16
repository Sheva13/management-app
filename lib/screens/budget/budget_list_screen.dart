import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/budget_provider.dart';
import '../../widgets/budget_progress_card.dart';
import '../../widgets/empty_state.dart';
import 'add_budget_screen.dart';
import 'budget_history_screen.dart';

class BudgetListScreen extends ConsumerWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final budgetSummaryAsync = ref.watch(budgetSummaryProvider(now));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.budget),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BudgetHistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddBudgetScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: budgetSummaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (data) {
          final budgets = data;
          if (budgets.isEmpty) {
            return EmptyState(
              icon: Icons.savings_rounded,
              title: AppStrings.emptyBudgets,
              subtitle: 'Atur anggaran untuk mengontrol pengeluaran',
              actionText: 'Tambah Budget',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddBudgetScreen(),
                  ),
                );
              },
            );
          }

          final totalBudget = budgets.fold<int>(
            0,
            (sum, b) => sum + b.amount,
          );
          final totalSpent = budgets.fold<int>(
            0,
            (sum, b) => sum + b.spent,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(totalBudget, totalSpent),
                const SizedBox(height: AppSizes.paddingLg),
                const Text(
                  'Anggaran per Kategori',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingMd),
                ...budgets.map((budget) {
                  return BudgetProgressCard(
                    budget: budget,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddBudgetScreen(
                            budgetId: budget.budgetId,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(int totalBudget, int totalSpent) {
    final remaining = totalBudget - totalSpent;
    final percentage = totalBudget > 0 ? (totalSpent / totalBudget) * 100 : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenPrimary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Anggaran',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.formatRupiah(totalBudget),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          Row(
            children: [
              _buildSummaryItem(
                'Terpakai',
                CurrencyFormatter.formatCompact(totalSpent),
                AppColors.greenPrimary,
              ),
              const SizedBox(width: AppSizes.paddingMd),
              _buildSummaryItem(
                'Sisa',
                CurrencyFormatter.formatCompact(remaining.clamp(0, remaining)),
                remaining >= 0 ? AppColors.greenPrimary : AppColors.redPrimary,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0) / 100,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: AppSizes.paddingSm),
          Text(
            '${percentage.toStringAsFixed(0)}% terpakai',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
