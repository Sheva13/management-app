import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/daos/log_dao.dart';
import 'transaction_provider.dart';

final allLogsProvider = StreamProvider<List<TransactionLogsTableData>>((ref) {
  final dao = ref.watch(logDaoProvider);
  return dao.watchAllLogs();
});

final logsByDateRangeProvider =
    StreamProvider.family<List<TransactionLogsTableData>, DateTime>((ref, date) {
  final dao = ref.watch(logDaoProvider);
  final start = DateTime(date.year, date.month, 1);
  final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  return dao.watchLogsByDateRange(start, end);
});

final logsByTypeProvider =
    StreamProvider.family<List<TransactionLogsTableData>, String>((ref, type) {
  final dao = ref.watch(logDaoProvider);
  return Stream.fromFuture(dao.getLogsByType(type));
});

class LogActions {
  final LogDao _dao;

  LogActions(this._dao);

  Future<List<TransactionLogsTableData>> getLogsByDateRange(
      DateTime start, DateTime end) {
    return _dao.getLogsByDateRange(start, end);
  }

  Future<List<TransactionLogsTableData>> getLogsByPlatform(String platformId) {
    return _dao.getLogsByPlatform(platformId);
  }

  Future<int> getLogCount() {
    return _dao.getLogCount();
  }
}
