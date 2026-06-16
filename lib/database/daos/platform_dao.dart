import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/platforms_table.dart';
import '../tables/money_types_table.dart';

part 'platform_dao.g.dart';

@DriftAccessor(tables: [PlatformsTable, MoneyTypesTable])
class PlatformDao extends DatabaseAccessor<AppDatabase>
    with _$PlatformDaoMixin {
  PlatformDao(super.db);

  Future<List<PlatformsTableData>> getAllPlatforms() {
    return (select(platformsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Stream<List<PlatformsTableData>> watchAllPlatforms() {
    return (select(platformsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<PlatformsTableData>> getPlatformsByMoneyType(
      String moneyTypeId) {
    return (select(platformsTable)
          ..where((t) => t.moneyTypeId.equals(moneyTypeId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Stream<List<PlatformsTableData>> watchPlatformsByMoneyType(
      String moneyTypeId) {
    return (select(platformsTable)
          ..where((t) => t.moneyTypeId.equals(moneyTypeId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<PlatformsTableData?> getPlatformById(String id) {
    return (select(platformsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertPlatform(Insertable<PlatformsTableData> platform) {
    return into(platformsTable).insert(platform);
  }

  Future<bool> updatePlatform(Insertable<PlatformsTableData> platform) {
    return update(platformsTable).replace(platform);
  }

  Future<int> deletePlatform(String id) {
    return (delete(platformsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<List<PlatformWithMoneyType>> getAllPlatformsWithMoneyType() async {
    final query = select(platformsTable).join([
      innerJoin(
        moneyTypesTable,
        moneyTypesTable.id.equalsExp(platformsTable.moneyTypeId),
      ),
    ]);

    final rows = await query.get();
    return rows.map((row) {
      return PlatformWithMoneyType(
        platform: row.readTable(platformsTable),
        moneyType: row.readTable(moneyTypesTable),
      );
    }).toList();
  }

  Stream<List<PlatformWithMoneyType>> watchAllPlatformsWithMoneyType() {
    final query = select(platformsTable).join([
      innerJoin(
        moneyTypesTable,
        moneyTypesTable.id.equalsExp(platformsTable.moneyTypeId),
      ),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return PlatformWithMoneyType(
          platform: row.readTable(platformsTable),
          moneyType: row.readTable(moneyTypesTable),
        );
      }).toList();
    });
  }
}

class PlatformWithMoneyType {
  final PlatformsTableData platform;
  final MoneyTypesTableData moneyType;

  PlatformWithMoneyType({
    required this.platform,
    required this.moneyType,
  });
}
