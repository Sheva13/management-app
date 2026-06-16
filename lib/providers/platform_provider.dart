import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../database/app_database.dart';
import '../database/daos/platform_dao.dart';
import '../core/utils/id_generator.dart';

final platformDaoProvider = Provider<PlatformDao>((ref) {
  final db = ref.watch(databaseProvider);
  return PlatformDao(db);
});

final allPlatformsProvider = StreamProvider<List<PlatformsTableData>>((ref) {
  final dao = ref.watch(platformDaoProvider);
  return dao.watchAllPlatforms();
});

final platformsByMoneyTypeProvider =
    StreamProvider.family<List<PlatformsTableData>, String>((ref, moneyTypeId) {
  final dao = ref.watch(platformDaoProvider);
  return dao.watchPlatformsByMoneyType(moneyTypeId);
});

final platformActionsProvider = Provider<PlatformActions>((ref) {
  final dao = ref.watch(platformDaoProvider);
  return PlatformActions(dao);
});

class PlatformActions {
  final PlatformDao _dao;

  PlatformActions(this._dao);

  Future<void> addPlatform({
    required String name,
    required String icon,
    required int color,
    required String moneyTypeId,
    int initialBalance = 0,
  }) async {
    final now = DateTime.now();
    final platform = PlatformsTableCompanion.insert(
      id: IdGenerator.generate(),
      name: name,
      icon: icon,
      color: color,
      moneyTypeId: moneyTypeId,
      initialBalance: Value(initialBalance),
      createdAt: now,
      updatedAt: now,
    );

    await _dao.insertPlatform(platform);
  }

  Future<void> updatePlatform({
    required String id,
    required String name,
    required String icon,
    required int color,
    required String moneyTypeId,
    required int initialBalance,
  }) async {
    final existing = await _dao.getPlatformById(id);
    if (existing == null) return;

    final updated = existing.copyWith(
      name: name,
      icon: icon,
      color: color,
      moneyTypeId: moneyTypeId,
      initialBalance: initialBalance,
      updatedAt: DateTime.now(),
    );

    await _dao.updatePlatform(updated);
  }

  Future<void> deletePlatform(String id) async {
    await _dao.deletePlatform(id);
  }
}
