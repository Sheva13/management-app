import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/empty_state.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(allTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Laporan'),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const EmptyState(
              icon: Icons.bar_chart_rounded,
              title: 'Belum ada data',
              subtitle: 'Tambahkan transaksi untuk melihat laporan',
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(transactions),
                const SizedBox(height: AppSizes.paddingLg),
                _buildPieChart(transactions),
                const SizedBox(height: AppSizes.paddingLg),
                _buildBarChart(transactions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(List transactions) {
    int totalIncome = 0;
    int totalExpense = 0;

    for (final t in transactions) {
      if (t.type == 'income') {
        totalIncome += (t.amount as num).toInt();
      } else {
        totalExpense += (t.amount as num).toInt();
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.formatRupiah(totalIncome - totalExpense),
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
                'Pemasukan',
                CurrencyFormatter.formatCompact(totalIncome),
                AppColors.greenPrimary,
              ),
              const SizedBox(width: AppSizes.paddingMd),
              _buildSummaryItem(
                'Pengeluaran',
                CurrencyFormatter.formatCompact(totalExpense),
                AppColors.redPrimary,
              ),
            ],
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
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List transactions) {
    final Map<String, int> categoryData = {};

    for (final t in transactions) {
      if (t.type == 'expense' && t.categoryId != null) {
        final category = t.categoryId!;
        categoryData[category] = (categoryData[category] ?? 0) + (t.amount as num).toInt();
      }
    }

    if (categoryData.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = [
      AppColors.greenPrimary,
      AppColors.redPrimary,
      const Color(0xFF42A5F5),
      const Color(0xFFAB47BC),
      const Color(0xFFFFCA28),
      const Color(0xFFEF5350),
      const Color(0xFF66BB6A),
      const Color(0xFF5C6BC0),
    ];

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
          const Text(
            'Distribusi Pengeluaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: categoryData.entries.toList().asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final percentage = (data.value /
                            categoryData.values
                                .fold(0, (sum, e) => sum + e)) *
                        100;

                    return PieChartSectionData(
                      value: data.value.toDouble(),
                      title: '${percentage.toStringAsFixed(0)}%',
                      color: colors[index % colors.length],
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    );
                  },
                ).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: categoryData.entries.toList().asMap().entries.map(
              (entry) {
                final index = entry.key;
                final data = entry.value;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      data.key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List transactions) {
    final Map<int, int> monthlyData = {};

    for (final t in transactions) {
      if (t.type == 'expense') {
        final month = t.date.month;
        monthlyData[month] = (monthlyData[month] ?? 0) + (t.amount as num).toInt();
      }
    }

    if (monthlyData.isEmpty) {
      return const SizedBox.shrink();
    }

    final barData = monthlyData.entries.map<BarChartGroupData>((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: AppColors.greenPrimary,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();

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
          const Text(
            'Tren Pengeluaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: monthlyData.values
                        .fold(0, (sum, e) => sum > e ? sum : e)
                        .toDouble() *
                    1.2,
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.textPrimary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        CurrencyFormatter.formatCompact(rod.toY.toInt()),
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final months = [
                          '',
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'Mei',
                          'Jun',
                          'Jul',
                          'Ags',
                          'Sep',
                          'Okt',
                          'Nov',
                          'Des'
                        ];
                        return Text(
                          months[value.toInt()],
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          CurrencyFormatter.formatCompact(value.toInt()),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: monthlyData.values
                          .fold(0, (sum, e) => sum > e ? sum : e)
                          .toDouble() /
                      4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.divider.withOpacity(0.5),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: barData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
