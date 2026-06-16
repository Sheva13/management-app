import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import '../../models/budget_with_category.dart';
import '../../widgets/money_type_selector.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/budget_progress_card.dart';
import '../money_type/money_type_detail_screen.dart';
import '../budget/budget_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoRollForwardProvider);
    final walletAsync = ref.watch(walletProvider);
    final transactionsAsync = ref.watch(recentTransactionsProvider);
    final platformBalancesAsync = ref.watch(platformBalancesProvider);
    final now = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final budgetSummaryAsync = ref.watch(budgetSummaryProvider(now));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSizes.paddingLg),
              _buildBalanceCard(walletAsync),
              const SizedBox(height: AppSizes.paddingLg),
              _buildMoneyTypeCard(
                context,
                walletAsync,
                platformBalancesAsync,
                ref,
              ),
              const SizedBox(height: AppSizes.paddingLg),
              _buildBudgetSummary(context, budgetSummaryAsync),
              const SizedBox(height: AppSizes.paddingLg),
              _buildRecentTransactions(transactionsAsync, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat ${_getGreeting()}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.greenPrimary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.greenPrimary,
            size: 24,
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Pagi';
    if (hour < 17) return 'Siang';
    return 'Malam';
  }

  Widget _buildBalanceCard(AsyncValue walletAsync) {
    return walletAsync.when(
      loading: () => const CardSkeleton(height: 180),
      error: (error, stack) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        decoration: BoxDecoration(
          gradient: AppColors.mainGradient,
          borderRadius: BorderRadius.circular(AppSizes.balanceCardRadius),
        ),
        child: const Center(
          child: Text(
            'Gagal memuat data',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      data: (wallet) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        decoration: BoxDecoration(
          gradient: AppColors.mainGradient,
          borderRadius: BorderRadius.circular(AppSizes.balanceCardRadius),
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
              AppStrings.totalBalance,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              CurrencyFormatter.formatRupiah(wallet.totalUang),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.paddingMd),
            Row(
              children: [
                _buildStatItem(
                  icon: Icons.arrow_downward_rounded,
                  label: AppStrings.income,
                  value: CurrencyFormatter.formatCompact(wallet.totalIncome),
                  isPositive: true,
                ),
                const SizedBox(width: AppSizes.paddingMd),
                _buildStatItem(
                  icon: Icons.arrow_upward_rounded,
                  label: AppStrings.expense,
                  value: CurrencyFormatter.formatCompact(wallet.totalExpense),
                  isPositive: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isPositive,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isPositive
                  ? const Color(0xFFA5D6A7)
                  : const Color(0xFFEF9A9A),
              size: 16,
            ),
            const SizedBox(width: 6),
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyTypeCard(
    BuildContext context,
    AsyncValue walletAsync,
    AsyncValue platformBalancesAsync,
    WidgetRef ref,
  ) {
    return walletAsync.when(
      loading: () => const CardSkeleton(height: 160),
      error: (error, stack) => const SizedBox.shrink(),
      data: (wallet) {
        final emoneyBreakdown = <String, int>{};
        final cashBreakdown = <String, int>{};

        platformBalancesAsync.whenData((balances) {
          for (final b in balances) {
            if (b.moneyType == 'emoney') {
              emoneyBreakdown[b.name] = b.currentBalance;
            } else {
              cashBreakdown[b.name] = b.currentBalance;
            }
          }
        });

        return MoneyTypeSelector(
          totalEMoney: wallet.totalEMoney,
          totalCash: wallet.totalCash,
          emoneyBreakdown: emoneyBreakdown,
          cashBreakdown: cashBreakdown,
          onTapEMoney: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MoneyTypeDetailScreen(moneyTypeId: 'mt_emoney'),
              ),
            );
          },
          onTapCash: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MoneyTypeDetailScreen(moneyTypeId: 'mt_cash'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBudgetSummary(
    BuildContext context,
    AsyncValue budgetSummaryAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Budget Bulan Ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BudgetListScreen()),
                );
              },
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        budgetSummaryAsync.when(
          loading: () => Column(
            children: List.generate(3, (_) => const CardSkeleton(height: 80)),
          ),
          error: (error, stack) =>
              const Center(child: Text('Gagal memuat budget')),
          data: (data) {
            final budgets = data as List<BudgetWithCategory>;
            if (budgets.isEmpty) {
              return const EmptyState(
                icon: Icons.savings_rounded,
                title: 'Belum ada budget',
                subtitle: 'Atur anggaran untuk mengontrol pengeluaran',
                actionText: 'Tambah Budget',
              );
            }

            final topBudgets = budgets
                .where((b) => b.percentage > 50)
                .take(3)
                .toList();

            if (topBudgets.isEmpty) {
              return const EmptyState(
                icon: Icons.savings_rounded,
                title: 'Budget aman',
                subtitle: 'Semua anggaran masih dalam batas aman',
              );
            }

            return Column(
              children: topBudgets.map<Widget>((budget) {
                return BudgetProgressCard(budget: budget);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(AsyncValue transactionsAsync, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terakhir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
          ],
        ),
        transactionsAsync.when(
          loading: () => Column(
            children: List.generate(3, (_) => const TransactionSkeleton()),
          ),
          error: (error, stack) =>
              const Center(child: Text('Gagal memuat transaksi')),
          data: (transactions) {
            if (transactions.isEmpty) {
              return const EmptyState(
                icon: Icons.receipt_long_rounded,
                title: AppStrings.emptyTransactions,
                subtitle: 'Mulai catat transaksi pertamamu',
                actionText: 'Tambah Transaksi',
              );
            }

            return Column(
              children: transactions.take(5).map<Widget>((transaction) {
                return _buildTransactionItem(transaction);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionItem(transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.type == 'income'
                  ? AppColors.greenPrimary.withOpacity(0.1)
                  : AppColors.redPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              transaction.type == 'income'
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: transaction.type == 'income'
                  ? AppColors.greenPrimary
                  : AppColors.redPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSizes.paddingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note ?? 'Transaksi',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatRelative(transaction.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.type == 'income' ? '+' : '-'}${CurrencyFormatter.formatRupiah(transaction.amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: transaction.type == 'income'
                  ? AppColors.greenPrimary
                  : AppColors.redPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
