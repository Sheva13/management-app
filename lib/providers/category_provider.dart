import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../database/app_database.dart';
import '../database/daos/category_dao.dart';
import '../core/utils/id_generator.dart';

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final db = ref.watch(databaseProvider);
  return CategoryDao(db);
});

final allCategoriesProvider = StreamProvider<List<CategoriesTableData>>((ref) {
  final dao = ref.watch(categoryDaoProvider);
  return dao.watchAllCategories();
});

final categoryActionsProvider = Provider<CategoryActions>((ref) {
  final dao = ref.watch(categoryDaoProvider);
  return CategoryActions(dao);
});

class CategoryActions {
  final CategoryDao _dao;

  CategoryActions(this._dao);

  Future<void> addCategory({
    required String name,
    required String icon,
    required int color,
  }) async {
    final now = DateTime.now();
    final category = CategoriesTableCompanion.insert(
      id: IdGenerator.generate(),
      name: name,
      icon: icon,
      color: color,
      isDefault: const Value(false),
      createdAt: now,
      updatedAt: now,
    );

    await _dao.insertCategory(category);
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String icon,
    required int color,
  }) async {
    final existing = await _dao.getCategoryById(id);
    if (existing == null) return;

    final updated = existing.copyWith(
      name: name,
      icon: icon,
      color: color,
      updatedAt: DateTime.now(),
    );

    await _dao.updateCategory(updated);
  }

  Future<void> deleteCategory(String id) async {
    await _dao.deleteCategory(id);
  }
}
