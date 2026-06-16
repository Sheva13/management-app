import 'package:drift/drift.dart';
import 'categories_table.dart';
import 'money_types_table.dart';
import 'platforms_table.dart';

class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  IntColumn get amount => integer()();
  TextColumn get type => text()();
  TextColumn get categoryId => text().nullable().references(CategoriesTable, #id)();
  TextColumn get moneyTypeId => text().references(MoneyTypesTable, #id)();
  TextColumn get platformId => text().nullable().references(PlatformsTable, #id)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
