import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/log_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_skeleton.dart';

class TransactionLogScreen extends ConsumerWidget {
  const TransactionLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(allLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.transactionLog),
      ),
      body: logsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          itemCount: 5,
          itemBuilder: (_, __) => const TransactionSkeleton(),
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (logs) {
          if (logs.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_rounded,
              title: AppStrings.emptyLogs,
              subtitle: 'Log keuangan akan muncul setelah ada transaksi',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return _LogItem(log: log);
            },
          );
        },
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final dynamic log;

  const _LogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    final isIncome = log.type == 'income';
    final isDelete = log.type == 'delete';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDelete
                      ? AppColors.error.withOpacity(0.1)
                      : isIncome
                          ? AppColors.greenPrimary.withOpacity(0.1)
                          : AppColors.redPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  isDelete
                      ? Icons.delete_rounded
                      : isIncome
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                  color: isDelete
                      ? AppColors.error
                      : isIncome
                          ? AppColors.greenPrimary
                          : AppColors.redPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.paddingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.formatLog(log.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getTypeLabel(log.type),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDelete
                            ? AppColors.error
                            : isIncome
                                ? AppColors.greenPrimary
                                : AppColors.redPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? '+' : isDelete ? '' : '-'}${CurrencyFormatter.formatRupiah(log.amount)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDelete
                      ? AppColors.error
                      : isIncome
                          ? AppColors.greenPrimary
                          : AppColors.redPrimary,
                ),
              ),
            ],
          ),
          if (log.note != null && log.note!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingSm),
            Text(
              log.note!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSizes.paddingSm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CurrencyFormatter.formatRupiah(log.balanceBefore),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 12,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(width: 6),
                Text(
                  CurrencyFormatter.formatRupiah(log.balanceAfter),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'income':
        return 'Pemasukan';
      case 'expense':
        return 'Pengeluaran';
      case 'delete':
        return 'Dihapus';
      default:
        return type;
    }
  }
}
