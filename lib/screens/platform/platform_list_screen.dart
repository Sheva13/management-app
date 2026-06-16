import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/platform_balance.dart';
import '../../providers/platform_provider.dart';
import '../../providers/money_type_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/toast_notification.dart';
import 'add_platform_screen.dart';

class PlatformListScreen extends ConsumerWidget {
  const PlatformListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformsAsync = ref.watch(allPlatformsProvider);
    final moneyTypesAsync = ref.watch(allMoneyTypesProvider);
    final platformBalancesAsync = ref.watch(platformBalancesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.platforms),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddPlatformScreen(moneyTypeId: 'mt_emoney'),
                ),
              );
            },
          ),
        ],
      ),
      body: platformBalancesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (balances) {
          if (balances.isEmpty) {
            return EmptyState(
              icon: Icons.credit_card_rounded,
              title: AppStrings.emptyPlatforms,
              subtitle: 'Tambahkan platform untuk menyimpan uang',
              actionText: 'Tambah Platform',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddPlatformScreen(moneyTypeId: 'mt_emoney'),
                  ),
                );
              },
            );
          }

          return moneyTypesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (moneyTypes) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                itemCount: balances.length,
                itemBuilder: (context, index) {
                  final balance = balances[index];
                  final moneyType = moneyTypes.firstWhere(
                    (mt) => mt.type == balance.moneyType,
                    orElse: () => moneyTypes.first,
                  );
                  return _PlatformItem(
                    balance: balance,
                    moneyTypeName: moneyType.name,
                    onDelete: () =>
                        _showDeleteDialog(context, ref, balance.platformId),
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddPlatformScreen(
                            platformId: balance.platformId,
                            moneyTypeId: balance.moneyType == 'emoney' ? 'mt_emoney' : 'mt_cash',
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String platformId) {
    ConfirmationDialog.show(
      context: context,
      title: 'Hapus Platform',
      message: 'Platform ini akan dihapus permanen beserta semua transaksinya.',
      confirmText: 'Hapus',
      onConfirm: () async {
        await ref.read(platformActionsProvider).deletePlatform(platformId);
        if (context.mounted) {
          ref.invalidate(platformBalancesProvider);
          ref.invalidate(walletProvider);
          ToastNotification.success(context, AppStrings.deletedSuccessfully);
        }
      },
    );
  }
}

class _PlatformItem extends StatelessWidget {
  final PlatformBalance balance;
  final String moneyTypeName;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _PlatformItem({
    required this.balance,
    required this.moneyTypeName,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = balance.currentBalance < 0;

    return Dismissible(
      key: Key(balance.platformId),
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
      child: GestureDetector(
        onTap: onEdit,
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
                  color: Color(balance.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  _getPlatformIcon(balance.icon),
                  color: Color(balance.color),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.paddingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      balance.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      moneyTypeName,
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
                    CurrencyFormatter.formatRupiah(balance.currentBalance),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isNegative ? AppColors.error : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Saldo awal: ${CurrencyFormatter.formatRupiah(balance.initialBalance)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
      default:
        return Icons.credit_card_rounded;
    }
  }
}
