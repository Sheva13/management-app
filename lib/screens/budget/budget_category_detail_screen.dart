import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../database/app_database.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/empty_state.dart';

enum SortOption { newest, oldest, az, za }

class BudgetCategoryDetailScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final int categoryColor;
  final int month;
  final int year;
  final int budgetAmount;

  const BudgetCategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.month,
    required this.year,
    required this.budgetAmount,
  });

  @override
  ConsumerState<BudgetCategoryDetailScreen> createState() =>
      _BudgetCategoryDetailScreenState();
}

class _BudgetCategoryDetailScreenState
    extends ConsumerState<BudgetCategoryDetailScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  SortOption _sortOption = SortOption.newest;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monthKey = DateTime(widget.year, widget.month, 1);

    final transactionsAsync = ref.watch(
      budgetCategoryTransactionsProvider(monthKey),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (allTransactions) {
          final filtered = allTransactions
              .where((t) =>
                  t.type == 'expense' && t.categoryId == widget.categoryId)
              .toList();

          final searched = _searchQuery.isEmpty
              ? filtered
              : filtered
                  .where((t) =>
                      (t.note ?? '')
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                  .toList();

          searched.sort(_getSortComparator());

          final totalSpent =
              filtered.fold<int>(0, (sum, t) => sum + t.amount);
          final percentage = widget.budgetAmount > 0
              ? (totalSpent / widget.budgetAmount) * 100
              : 0.0;

          return Column(
            children: [
              _buildSummaryCard(totalSpent, percentage),
              _buildSearchAndSort(),
              Expanded(
                child: searched.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_rounded,
                        title: 'Belum ada pengeluaran',
                        subtitle: _searchQuery.isNotEmpty
                            ? 'Tidak ada hasil untuk "$_searchQuery"'
                            : 'Tidak ada transaksi untuk kategori ini di bulan ini',
                        actionText: null,
                        onAction: null,
                      )
                    : _buildTransactionList(searched),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(int totalSpent, double percentage) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppSizes.paddingMd),
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  _getCategoryIcon(widget.categoryIcon),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.paddingMd),
              Text(
                widget.categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMd),
          Text(
            'Terpakai',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${CurrencyFormatter.formatRupiah(totalSpent)} / ${CurrencyFormatter.formatRupiah(widget.budgetAmount)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 100.0) / 100,
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

  Widget _buildSearchAndSort() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Cari pengeluaran...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
            ),
          ),
          const SizedBox(height: AppSizes.paddingSm),
          Row(
            children: [
              const Icon(Icons.sort_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Urutkan:',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              DropdownButton<SortOption>(
                value: _sortOption,
                isDense: true,
                underline: const SizedBox.shrink(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                items: const [
                  DropdownMenuItem(
                    value: SortOption.newest,
                    child: Text('Terkini'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.oldest,
                    child: Text('Terlama'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.az,
                    child: Text('A → Z'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.za,
                    child: Text('Z → A'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _sortOption = value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionsTableData> transactions) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final t = transactions[index];
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.redPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.redPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSizes.paddingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.formatFull(t.date),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.note ?? 'Transaksi',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                '-${CurrencyFormatter.formatRupiah(t.amount)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.redPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Comparator<TransactionsTableData> _getSortComparator() {
    switch (_sortOption) {
      case SortOption.newest:
        return (a, b) => b.date.compareTo(a.date);
      case SortOption.oldest:
        return (a, b) => a.date.compareTo(b.date);
      case SortOption.az:
        return (a, b) => (a.note ?? '').compareTo(b.note ?? '');
      case SortOption.za:
        return (a, b) => (b.note ?? '').compareTo(a.note ?? '');
    }
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'movie':
        return Icons.movie_rounded;
      case 'receipt':
        return Icons.receipt_rounded;
      case 'local_hospital':
        return Icons.local_hospital_rounded;
      case 'school':
        return Icons.school_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }
}

final budgetCategoryTransactionsProvider =
    StreamProvider.family<List<TransactionsTableData>, DateTime>(
        (ref, monthKey) async* {
  final transactionDao = ref.watch(transactionDaoProvider);

  final startOfMonth = DateTime(monthKey.year, monthKey.month, 1);
  final endOfMonth = DateTime(monthKey.year, monthKey.month + 1, 0, 23, 59, 59);

  await for (final transactions in transactionDao.watchTransactionsByDateRange(
      startOfMonth, endOfMonth)) {
    yield transactions;
  }
});
