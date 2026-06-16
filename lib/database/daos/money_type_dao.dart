import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/money_types_table.dart';

part 'money_type_dao.g.dart';

@DriftAccessor(tables: [MoneyTypesTable])
class MoneyTypeDao extends DatabaseAccessor<AppDatabase>
    with _$MoneyTypeDaoMixin {
  MoneyTypeDao(super.db);

  Future<List<MoneyTypesTableData>> getAllMoneyTypes() {
    return (select(moneyTypesTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Stream<List<MoneyTypesTableData>> watchAllMoneyTypes() {
    return (select(moneyTypesTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<MoneyTypesTableData>> getMoneyTypesByType(String type) {
    return (select(moneyTypesTable)
          ..where((t) => t.type.equals(type))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<MoneyTypesTableData?> getMoneyTypeById(String id) {
    return (select(moneyTypesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<MoneyTypesTableData?> getMoneyTypeByName(String name) {
    return (select(moneyTypesTable)
          ..where((t) => t.name.equals(name)))
        .getSingleOrNull();
  }

  Future<int> insertMoneyType(Insertable<MoneyTypesTableData> moneyType) {
    return into(moneyTypesTable).insert(moneyType);
  }

  Future<bool> updateMoneyType(Insertable<MoneyTypesTableData> moneyType) {
    return update(moneyTypesTable).replace(moneyType);
  }

  Future<int> deleteMoneyType(String id) {
    return (delete(moneyTypesTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}
