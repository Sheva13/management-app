import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/daos/transaction_dao.dart';
import '../database/daos/money_type_dao.dart';
import '../database/daos/platform_dao.dart';
import '../models/wallet_summary.dart';
import '../models/platform_balance.dart';
import 'transaction_provider.dart';
import 'money_type_provider.dart';
import 'platform_provider.dart';

final walletProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<WalletSummary>>((ref) {
  final transactionDao = ref.watch(transactionDaoProvider);
  final moneyTypeDao = ref.watch(moneyTypeDaoProvider);
  final platformDao = ref.watch(platformDaoProvider);
  return WalletNotifier(transactionDao, moneyTypeDao, platformDao)..recalculate();
});

final platformBalancesProvider =
    FutureProvider<List<PlatformBalance>>((ref) async {
  final transactionDao = ref.watch(transactionDaoProvider);
  final platformDao = ref.watch(platformDaoProvider);

  final platformsWithMoneyType = await platformDao.getAllPlatformsWithMoneyType();
  final balances = <PlatformBalance>[];

  for (final pm in platformsWithMoneyType) {
    final transactionSum = await transactionDao.getBalanceByPlatform(pm.platform.id);
    final currentBalance = pm.platform.initialBalance + transactionSum;

    balances.add(PlatformBalance(
      platformId: pm.platform.id,
      name: pm.platform.name,
      icon: pm.platform.icon,
      color: pm.platform.color,
      moneyType: pm.moneyType.type,
      initialBalance: pm.platform.initialBalance,
      transactionSum: transactionSum,
      currentBalance: currentBalance,
    ));
  }

  return balances;
});

class WalletNotifier extends StateNotifier<AsyncValue<WalletSummary>> {
  final TransactionDao _transactionDao;
  final MoneyTypeDao _moneyTypeDao;
  final PlatformDao _platformDao;

  WalletNotifier(this._transactionDao, this._moneyTypeDao, this._platformDao)
      : super(const AsyncValue.loading());

  Future<void> recalculate() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final platformsWithMoneyType = await _platformDao.getAllPlatformsWithMoneyType();

      int totalEMoney = 0;
      int totalCash = 0;

      for (final pm in platformsWithMoneyType) {
        final transactionSum = await _transactionDao.getBalanceByPlatform(pm.platform.id);
        final currentBalance = pm.platform.initialBalance + transactionSum;

        if (pm.moneyType.type == 'emoney') {
          totalEMoney += currentBalance;
        } else {
          totalCash += currentBalance;
        }
      }

      final totalIncome = await _transactionDao.getTotalIncome();
      final totalExpense = await _transactionDao.getTotalExpense();
      final totalBalance = totalEMoney + totalCash;

      return WalletSummary(
        totalUang: totalBalance,
        totalEMoney: totalEMoney,
        totalCash: totalCash,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      );
    });
  }

  Future<void> refresh() async {
    await recalculate();
  }

  Future<int> getBalanceByPlatform(String platformId) {
    return _transactionDao.getBalanceByPlatform(platformId);
  }
}
