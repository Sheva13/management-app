import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/money_type_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/platform_provider.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/toast_notification.dart';
import '../platform/add_platform_screen.dart';

class MoneyTypeDetailScreen extends ConsumerWidget {
  final String moneyTypeId;

  const MoneyTypeDetailScreen({super.key, required this.moneyTypeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moneyTypeAsync = ref.watch(moneyTypeByIdProvider(moneyTypeId));
    final balancesAsync = ref.watch(platformBalancesProvider);

    return moneyTypeAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.white,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: Text('Error: $error')),
      ),
      data: (moneyType) {
        if (moneyType == null) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: const Center(child: Text('Jenis uang tidak ditemukan')),
          );
        }

        final isEMoney = moneyType.type == 'emoney';

        return Scaffold(
          backgroundColor: AppColors.white,
          body: balancesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (balances) {
              final platforms = balances
                  .where((b) => b.moneyType == moneyType.type)
                  .toList();

              final totalBalance =
                  platforms.fold<int>(0, (sum, b) => sum + b.currentBalance);

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    pinned: true,
                    backgroundColor: isEMoney
                        ? AppColors.greenPrimary
                        : AppColors.redPrimary,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        moneyType.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: isEMoney
                              ? AppColors.greenGradient
                              : AppColors.redGradient,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Total Saldo',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.formatRupiah(totalBalance),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (platforms.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text('Belum ada platform'),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final platform = platforms[index];
                          return _PlatformItem(
                            platform: platform,
                            isEMoney: isEMoney,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddPlatformScreen(
                                    platformId: platform.platformId,
                                    moneyTypeId: moneyTypeId,
                                  ),
                                ),
                              );
                            },
                            onDelete: () {
                              ConfirmationDialog.show(
                                context: context,
                                title: 'Hapus Platform',
                                message:
                                    'Platform "${platform.name}" akan dihapus permanen.',
                                confirmText: 'Hapus',
                                onConfirm: () async {
                                  await ref
                                      .read(platformActionsProvider)
                                      .deletePlatform(platform.platformId);
                                  if (context.mounted) {
                                    ref.invalidate(platformBalancesProvider);
                                    ref.invalidate(walletProvider);
                                    ToastNotification.success(
                                        context, 'Berhasil dihapus!');
                                  }
                                },
                              );
                            },
                          );
                        },
                        childCount: platforms.length,
                      ),
                    ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPlatformScreen(moneyTypeId: moneyTypeId),
                ),
              );
            },
            backgroundColor:
                isEMoney ? AppColors.greenPrimary : AppColors.redPrimary,
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        );
      },
    );
  }
}

class _PlatformItem extends StatelessWidget {
  final dynamic platform;
  final bool isEMoney;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PlatformItem({
    required this.platform,
    required this.isEMoney,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = platform.currentBalance < 0;

    return Dismissible(
      key: Key(platform.platformId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.paddingMd),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingSm,
        ),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMd,
            vertical: AppSizes.paddingSm,
          ),
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
                  color: Color(platform.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  _getPlatformIcon(platform.icon),
                  color: Color(platform.color),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.paddingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saldo awal: ${CurrencyFormatter.formatRupiah(platform.initialBalance)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.formatRupiah(platform.currentBalance),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isNegative ? AppColors.error : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String iconName) {
    switch (iconName) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_rounded;
      case 'phone_android':
        return Icons.phone_android_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'credit_card':
        return Icons.credit_card_rounded;
      case 'payments':
        return Icons.payments_rounded;
      default:
        return Icons.credit_card_rounded;
    }
  }
}
