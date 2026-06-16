import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';

class TransactionDetailScreen extends StatelessWidget {
  final dynamic transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSizes.paddingLg),
            _buildDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        gradient: transaction.type == 'income'
            ? AppColors.greenGradient
            : AppColors.redGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Column(
        children: [
          Icon(
            transaction.type == 'income'
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: AppSizes.paddingSm),
          Text(
            transaction.type == 'income'
                ? AppStrings.income
                : AppStrings.expense,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.formatRupiah(transaction.amount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            Icons.calendar_today_rounded,
            'Tanggal',
            DateFormatter.formatFullDateTime(transaction.date),
          ),
          if (transaction.categoryId != null) ...[
            const Divider(height: AppSizes.paddingLg),
            _buildDetailRow(
              Icons.category_rounded,
              'Kategori',
              transaction.categoryId!,
            ),
          ],
          if (transaction.platformId != null) ...[
            const Divider(height: AppSizes.paddingLg),
            _buildDetailRow(
              Icons.account_balance_rounded,
              'Platform',
              transaction.platformId!,
            ),
          ],
          if (transaction.note != null && transaction.note!.isNotEmpty) ...[
            const Divider(height: AppSizes.paddingLg),
            _buildDetailRow(
              Icons.notes_rounded,
              'Catatan',
              transaction.note!,
            ),
          ],
          const Divider(height: AppSizes.paddingLg),
          _buildDetailRow(
            Icons.access_time_rounded,
            'Dibuat',
            DateFormatter.formatFullDateTime(transaction.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
