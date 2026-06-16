import 'package:drift/drift.dart';
import 'money_types_table.dart';

class PlatformsTable extends Table {
  @override
  String get tableName => 'platforms';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  TextColumn get moneyTypeId => text().references(MoneyTypesTable, #id)();
  IntColumn get initialBalance => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
