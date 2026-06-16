import 'package:drift/drift.dart';
import 'categories_table.dart';

class BudgetsTable extends Table {
  @override
  String get tableName => 'budgets';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get categoryId => text().references(CategoriesTable, #id)();
  IntColumn get amount => integer()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
