import 'package:drift/drift.dart';

class MoneyTypesTable extends Table {
  @override
  String get tableName => 'money_types';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
