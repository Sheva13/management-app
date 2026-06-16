import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/budgets_table.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [BudgetsTable])
class BudgetDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Stream<List<BudgetsTableData>> watchAllBudgets(int month, int year) {
    return (select(budgetsTable)
          ..where((b) => b.month.equals(month) & b.year.equals(year))
          ..orderBy([(b) => OrderingTerm.asc(b.createdAt)]))
        .watch();
  }

  Future<List<BudgetsTableData>> getAllBudgets(int month, int year) {
    return (select(budgetsTable)
          ..where((b) => b.month.equals(month) & b.year.equals(year))
          ..orderBy([(b) => OrderingTerm.asc(b.createdAt)]))
        .get();
  }

  Future<BudgetsTableData?> getBudgetByCategory(
      String categoryId, int month, int year) {
    return (select(budgetsTable)
          ..where((b) =>
              b.categoryId.equals(categoryId) &
              b.month.equals(month) &
              b.year.equals(year)))
        .getSingleOrNull();
  }

  Future<BudgetsTableData?> getBudgetById(String id) {
    return (select(budgetsTable)..where((b) => b.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertBudget(Insertable<BudgetsTableData> budget) {
    return into(budgetsTable).insert(budget);
  }

  Future<bool> updateBudget(Insertable<BudgetsTableData> budget) {
    return update(budgetsTable).replace(budget);
  }

  Future<int> deleteBudget(String id) {
    return (delete(budgetsTable)..where((b) => b.id.equals(id))).go();
  }

  Future<int> getTotalBudget(int month, int year) async {
    final result = await customSelect(
      'SELECT COALESCE(SUM(amount), 0) as total FROM budgets WHERE month = ? AND year = ?',
      variables: [Variable.withInt(month), Variable.withInt(year)],
    ).getSingle();
    return result.data['total'] as int;
  }

  Future<bool> hasBudgets(int month, int year) async {
    final budgets = await getAllBudgets(month, year);
    return budgets.isNotEmpty;
  }

  Future<int> copyBudgetsToMonth({
    required int fromMonth,
    required int fromYear,
    required int toMonth,
    required int toYear,
  }) async {
    final sourceBudgets = await getAllBudgets(fromMonth, fromYear);
    int copied = 0;

    for (final source in sourceBudgets) {
      final existing = await getBudgetByCategory(
        source.categoryId,
        toMonth,
        toYear,
      );
      if (existing == null) {
        final now = DateTime.now();
        await insertBudget(BudgetsTableCompanion.insert(
          id: _generateId(),
          categoryId: source.categoryId,
          amount: source.amount,
          month: toMonth,
          year: toYear,
          createdAt: now,
          updatedAt: now,
        ));
        copied++;
      }
    }
    return copied;
  }

  String _generateId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = now.hashCode.toRadixString(36);
    return 'budget_$random';
  }
}
