import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/utils/currency_formatter.dart';
import '../models/budget_with_category.dart';

class BudgetProgressCard extends StatelessWidget {
  final BudgetWithCategory budget;
  final VoidCallback? onTap;

  const BudgetProgressCard({
    super.key,
    required this.budget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = _getProgressColor(budget.percentage);

    return GestureDetector(
      onTap: onTap,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(budget.categoryColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(
                    _getCategoryIcon(budget.categoryIcon),
                    color: Color(budget.categoryColor),
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.categoryName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${CurrencyFormatter.formatRupiah(budget.spent)} / ${CurrencyFormatter.formatRupiah(budget.amount)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${budget.percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: progressColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: budget.percentage / 100,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: AppSizes.paddingSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sisa: ${CurrencyFormatter.formatRupiah(budget.remaining.clamp(0, budget.remaining))}',
                  style: TextStyle(
                    fontSize: 11,
                    color: budget.remaining < 0 ? AppColors.error : AppColors.textSecondary,
                  ),
                ),
                Text(
                  budget.remaining < 0 ? 'Melebihi anggaran' : 'Tersisa',
                  style: TextStyle(
                    fontSize: 11,
                    color: budget.remaining < 0 ? AppColors.error : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 90) return AppColors.error;
    if (percentage >= 70) return AppColors.warning;
    return AppColors.greenPrimary;
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
