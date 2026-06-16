import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<List<CategoriesTableData>> getAllCategories() {
    return (select(categoriesTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Stream<List<CategoriesTableData>> watchAllCategories() {
    return (select(categoriesTable)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<CategoriesTableData?> getCategoryById(String id) {
    return (select(categoriesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<CategoriesTableData?> getCategoryByName(String name) {
    return (select(categoriesTable)
          ..where((t) => t.name.equals(name)))
        .getSingleOrNull();
  }

  Future<int> insertCategory(Insertable<CategoriesTableData> category) {
    return into(categoriesTable).insert(category);
  }

  Future<bool> updateCategory(Insertable<CategoriesTableData> category) {
    return update(categoriesTable).replace(category);
  }

  Future<int> deleteCategory(String id) {
    return (delete(categoriesTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<int> getCategoryCount() async {
    final result = await customSelect(
      'SELECT COUNT(*) as count FROM categories',
    ).getSingle();
    return result.data['count'] as int;
  }
}
