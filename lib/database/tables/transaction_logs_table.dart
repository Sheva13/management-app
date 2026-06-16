import 'package:drift/drift.dart';
import 'transactions_table.dart';
import 'platforms_table.dart';

class TransactionLogsTable extends Table {
  @override
  String get tableName => 'transaction_logs';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get transactionId => text().references(TransactionsTable, #id)();
  TextColumn get type => text()();
  TextColumn get platformId => text().nullable().references(PlatformsTable, #id)();
  IntColumn get amount => integer()();
  IntColumn get balanceBefore => integer()();
  IntColumn get balanceAfter => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
