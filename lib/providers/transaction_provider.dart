import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../database/app_database.dart';
import '../database/daos/transaction_dao.dart';
import '../database/daos/log_dao.dart';
import '../core/utils/id_generator.dart';

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionDao(db);
});

final logDaoProvider = Provider<LogDao>((ref) {
  final db = ref.watch(databaseProvider);
  return LogDao(db);
});

final allTransactionsProvider = StreamProvider<List<TransactionsTableData>>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return dao.watchAllTransactions();
});

final recentTransactionsProvider = StreamProvider<List<TransactionsTableData>>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return Stream.fromFuture(dao.getRecentTransactions(limit: 10));
});

final transactionActionsProvider = Provider<TransactionActions>((ref) {
  final transactionDao = ref.watch(transactionDaoProvider);
  final logDao = ref.watch(logDaoProvider);
  return TransactionActions(transactionDao, logDao);
});

class TransactionActions {
  final TransactionDao _transactionDao;
  final LogDao _logDao;

  TransactionActions(this._transactionDao, this._logDao);

  Future<void> addTransaction({
    required int amount,
    required String type,
    String? categoryId,
    required String moneyTypeId,
    String? platformId,
    String? note,
    required DateTime date,
  }) async {
    final now = DateTime.now();
    final id = IdGenerator.generate();

    final transaction = TransactionsTableCompanion.insert(
      id: id,
      amount: amount,
      type: type,
      categoryId: Value(categoryId),
      moneyTypeId: moneyTypeId,
      platformId: Value(platformId),
      note: Value(note),
      date: date,
      createdAt: now,
      updatedAt: now,
    );

    await _transactionDao.insertTransaction(transaction);

    final balanceBefore = await _getBalanceForPlatform(platformId);
    final balanceAfter = type == 'income'
        ? balanceBefore + amount
        : balanceBefore - amount;

    final log = TransactionLogsTableCompanion.insert(
      id: IdGenerator.generate(),
      transactionId: id,
      type: type,
      platformId: Value(platformId),
      amount: amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      note: Value(note),
      createdAt: now,
    );

    await _logDao.insertLog(log);
  }

  Future<void> deleteTransaction(String id) async {
    final transaction = await _transactionDao.getTransactionById(id);
    if (transaction == null) return;

    final now = DateTime.now();
    final balanceBefore = await _getBalanceForPlatform(transaction.platformId);
    final balanceAfter = transaction.type == 'income'
        ? balanceBefore - transaction.amount
        : balanceBefore + transaction.amount;

    final log = TransactionLogsTableCompanion.insert(
      id: IdGenerator.generate(),
      transactionId: id,
      type: 'delete',
      platformId: Value(transaction.platformId),
      amount: transaction.amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      note: const Value('Transaksi dihapus'),
      createdAt: now,
    );

    await _logDao.insertLog(log);
    await _transactionDao.deleteTransaction(id);
  }

  Future<int> _getBalanceForPlatform(String? platformId) async {
    if (platformId == null) {
      return await _transactionDao.getBalance();
    }
    return await _transactionDao.getBalanceByPlatform(platformId);
  }
}
