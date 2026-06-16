import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/money_type_provider.dart';
import '../../providers/wallet_provider.dart';
import 'money_type_detail_screen.dart';

class MoneyTypeListScreen extends ConsumerWidget {
  const MoneyTypeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moneyTypesAsync = ref.watch(allMoneyTypesProvider);
    final walletAsync = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.moneyTypes),
      ),
      body: moneyTypesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (moneyTypes) {
          if (moneyTypes.isEmpty) {
            return const Center(
              child: Text('Belum ada jenis uang'),
            );
          }

          return walletAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (wallet) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                itemCount: moneyTypes.length,
                itemBuilder: (context, index) {
                  final moneyType = moneyTypes[index];
                  final isEMoney = moneyType.type == 'emoney';
                  final total = isEMoney ? wallet.totalEMoney : wallet.totalCash;

                  return _MoneyTypeCard(
                    name: moneyType.name,
                    type: moneyType.type,
                    total: total,
                    icon: isEMoney
                        ? Icons.account_balance_wallet_rounded
                        : Icons.payments_rounded,
                    gradient: isEMoney
                        ? AppColors.greenGradient
                        : AppColors.redGradient,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MoneyTypeDetailScreen(
                            moneyTypeId: moneyType.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _MoneyTypeCard extends StatelessWidget {
  final String name;
  final String type;
  final int total;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _MoneyTypeCard({
    required this.name,
    required this.type,
    required this.total,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: (type == 'emoney'
                      ? AppColors.greenPrimary
                      : AppColors.redPrimary)
                  .withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.formatRupiah(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white70,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
