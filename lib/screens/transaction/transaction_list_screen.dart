import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/money_type_provider.dart';
import '../../providers/platform_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/toast_notification.dart';
import 'add_transaction_screen.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(allTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.transactions),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddTransactionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: transactionsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          itemCount: 5,
          itemBuilder: (_, __) => const TransactionSkeleton(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_rounded,
              title: AppStrings.emptyTransactions,
              subtitle: 'Mulai catat transaksi pertamamu',
              actionText: 'Tambah Sekarang',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddTransactionScreen(),
                  ),
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return _TransactionItem(
                transaction: transaction,
                onDelete: () => _showDeleteDialog(context, ref, transaction),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, transaction) {
    ConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteTransaction,
      message: '${transaction.note ?? 'Transaksi'} sebesar '
          '${CurrencyFormatter.formatRupiah(transaction.amount)} '
          'akan dihapus permanen.',
      confirmText: 'Hapus',
      onConfirm: () async {
        await ref
            .read(transactionActionsProvider)
            .deleteTransaction(transaction.id);
        if (context.mounted) {
          ref.invalidate(platformBalancesProvider);
          ref.invalidate(walletProvider);
          ToastNotification.success(context, AppStrings.deletedSuccessfully);
        }
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final dynamic transaction;
  final VoidCallback onDelete;

  const _TransactionItem({
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.paddingMd),
        margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
        ),
      ),
      child: Container(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                const SizedBox(height: 4),
                Text(
                  transaction.type == 'income'
                      ? AppStrings.income
                      : AppStrings.expense,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
