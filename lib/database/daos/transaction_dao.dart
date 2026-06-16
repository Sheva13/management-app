import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transactions_table.dart';
import '../tables/categories_table.dart';
import '../tables/money_types_table.dart';
import '../tables/platforms_table.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [
  TransactionsTable,
  CategoriesTable,
  MoneyTypesTable,
  PlatformsTable,
])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<List<TransactionsTableData>> getAllTransactions() {
    return (select(transactionsTable)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Stream<List<TransactionsTableData>> watchAllTransactions() {
    return (select(transactionsTable)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<List<TransactionsTableData>> getTransactionsByType(String type) {
    return (select(transactionsTable)
          ..where((t) => t.type.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<TransactionsTableData>> getTransactionsByCategory(
      String categoryId) {
    return (select(transactionsTable)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<TransactionsTableData>> getTransactionsByDateRange(
      DateTime start, DateTime end) {
    return (select(transactionsTable)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Stream<List<TransactionsTableData>> watchTransactionsByDateRange(
      DateTime start, DateTime end) {
    return (select(transactionsTable)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<TransactionsTableData?> getTransactionById(String id) {
    return (select(transactionsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertTransaction(
      Insertable<TransactionsTableData> transaction) {
    return into(transactionsTable).insert(transaction);
  }

  Future<bool> updateTransaction(
      Insertable<TransactionsTableData> transaction) {
    return update(transactionsTable).replace(transaction);
  }

  Future<int> deleteTransaction(String id) {
    return (delete(transactionsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<int> getTotalIncome() async {
    final result = await customSelect(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = ?',
      variables: [Variable.withString('income')],
    ).getSingle();
    return result.data['total'] as int;
  }

  Future<int> getTotalExpense() async {
    final result = await customSelect(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = ?',
      variables: [Variable.withString('expense')],
    ).getSingle();
    return result.data['total'] as int;
  }

  Future<int> getBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();
    return income - expense;
  }

  Future<int> getBalanceByPlatform(String platformId) async {
    final income = await customSelect(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = ? AND platform_id = ?',
      variables: [
        Variable.withString('income'),
        Variable.withString(platformId)
      ],
    ).getSingle();
    final expense = await customSelect(
      'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = ? AND platform_id = ?',
      variables: [
        Variable.withString('expense'),
        Variable.withString(platformId)
      ],
    ).getSingle();
    return (income.data['total'] as int) - (expense.data['total'] as int);
  }

  Future<int> getBalanceByMoneyType(String moneyTypeId) async {
    final income = await customSelect(
      '''SELECT COALESCE(SUM(t.amount), 0) as total 
         FROM transactions t 
         JOIN money_types mt ON t.money_type_id = mt.id 
         WHERE t.type = ? AND mt.id = ?''',
      variables: [
        Variable.withString('income'),
        Variable.withString(moneyTypeId)
      ],
    ).getSingle();
    final expense = await customSelect(
      '''SELECT COALESCE(SUM(t.amount), 0) as total 
         FROM transactions t 
         JOIN money_types mt ON t.money_type_id = mt.id 
         WHERE t.type = ? AND mt.id = ?''',
      variables: [
        Variable.withString('expense'),
        Variable.withString(moneyTypeId)
      ],
    ).getSingle();
    return (income.data['total'] as int) - (expense.data['total'] as int);
  }

  Future<List<TransactionsTableData>> getRecentTransactions(
      {int limit = 10}) {
    return (select(transactionsTable)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .get();
  }
}
