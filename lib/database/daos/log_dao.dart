import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transaction_logs_table.dart';
import '../tables/transactions_table.dart';
import '../tables/platforms_table.dart';

part 'log_dao.g.dart';

@DriftAccessor(tables: [
  TransactionLogsTable,
  TransactionsTable,
  PlatformsTable,
])
class LogDao extends DatabaseAccessor<AppDatabase> with _$LogDaoMixin {
  LogDao(super.db);

  Future<List<TransactionLogsTableData>> getAllLogs() {
    return (select(transactionLogsTable)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Stream<List<TransactionLogsTableData>> watchAllLogs() {
    return (select(transactionLogsTable)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<TransactionLogsTableData>> getLogsByDateRange(
      DateTime start, DateTime end) {
    return (select(transactionLogsTable)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Stream<List<TransactionLogsTableData>> watchLogsByDateRange(
      DateTime start, DateTime end) {
    return (select(transactionLogsTable)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<TransactionLogsTableData>> getLogsByType(String type) {
    return (select(transactionLogsTable)
          ..where((t) => t.type.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<List<TransactionLogsTableData>> getLogsByPlatform(
      String platformId) {
    return (select(transactionLogsTable)
          ..where((t) => t.platformId.equals(platformId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<TransactionLogsTableData?> getLogById(String id) {
    return (select(transactionLogsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertLog(Insertable<TransactionLogsTableData> log) {
    return into(transactionLogsTable).insert(log);
  }

  Future<int> getLogCount() async {
    final result = await customSelect(
      'SELECT COUNT(*) as count FROM transaction_logs',
    ).getSingle();
    return result.data['count'] as int;
  }

  Future<List<TransactionLogsTableData>> getRecentLogs({int limit = 20}) {
    return (select(transactionLogsTable)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }
}
