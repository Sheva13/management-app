import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/budget_provider.dart';
import '../../widgets/budget_progress_card.dart';
import '../../widgets/empty_state.dart';
import 'budget_category_detail_screen.dart';

class BudgetHistoryScreen extends ConsumerStatefulWidget {
  const BudgetHistoryScreen({super.key});

  @override
  ConsumerState<BudgetHistoryScreen> createState() =>
      _BudgetHistoryScreenState();
}

class _BudgetHistoryScreenState extends ConsumerState<BudgetHistoryScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month - 1, 1);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    final now = DateTime(DateTime.now().year, DateTime.now().month, 1);
    if (_selectedMonth.isBefore(now)) {
      setState(() {
        _selectedMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + 1,
          1,
        );
      });
    }
  }

  bool get _canGoNext {
    final now = DateTime(DateTime.now().year, DateTime.now().month, 1);
    return _selectedMonth.isBefore(now);
  }

  String get _monthLabel {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);

    if (_selectedMonth == currentMonth) {
      return 'Bulan Ini';
    }

    final diff = (currentMonth.year - _selectedMonth.year) * 12 +
        (currentMonth.month - _selectedMonth.month);

    if (diff == 1) return 'Bulan Lalu';

    return DateFormat('MMMM yyyy', 'id_ID').format(_selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    final budgetSummaryAsync = ref.watch(budgetSummaryProvider(_selectedMonth));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Riwayat Anggaran'),
      ),
      body: Column(
        children: [
          _buildMonthSelector(),
          Expanded(
            child: budgetSummaryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (data) {
                final budgets = data;
                if (budgets.isEmpty) {
                  return EmptyState(
                    icon: Icons.savings_rounded,
                    title: 'Belum ada anggaran',
                    subtitle:
                        'Anggaran untuk ${DateFormat('MMMM yyyy', 'id_ID').format(_selectedMonth)} belum dibuat',
                    actionText: null,
                    onAction: null,
                  );
                }

                final totalBudget =
                    budgets.fold<int>(0, (sum, b) => sum + b.amount);
                final totalSpent =
                    budgets.fold<int>(0, (sum, b) => sum + b.spent);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCard(totalBudget, totalSpent),
                      const SizedBox(height: AppSizes.paddingLg),
                      Text(
                        'Anggaran per Kategori',
                        style: const TextStyle(
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
                                builder: (_) => BudgetCategoryDetailScreen(
                                  categoryId: budget.categoryId,
                                  categoryName: budget.categoryName,
                                  categoryIcon: budget.categoryIcon,
                                  categoryColor: budget.categoryColor,
                                  month: _selectedMonth.month,
                                  year: _selectedMonth.year,
                                  budgetAmount: budget.amount,
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
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingSm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(Icons.chevron_left_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.textPrimary.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                _monthLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('MMMM yyyy', 'id_ID').format(_selectedMonth),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: _canGoNext ? _nextMonth : null,
            icon: const Icon(Icons.chevron_right_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.textPrimary.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int totalBudget, int totalSpent) {
    final remaining = totalBudget - totalSpent;
    final percentage =
        totalBudget > 0 ? (totalSpent / totalBudget) * 100 : 0.0;

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
              ),
              const SizedBox(width: AppSizes.paddingMd),
              _buildSummaryItem(
                'Sisa',
                CurrencyFormatter.formatCompact(
                    remaining.clamp(0, remaining)),
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

  Widget _buildSummaryItem(String label, String value) {
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
