import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import 'transaction_provider.dart';
import 'category_provider.dart';
import '../database/app_database.dart';
import '../database/daos/budget_dao.dart';
import '../models/budget_with_category.dart';
import '../core/utils/id_generator.dart';

final budgetDaoProvider = Provider<BudgetDao>((ref) {
  final db = ref.watch(databaseProvider);
  return BudgetDao(db);
});

final allBudgetsProvider =
    StreamProvider.family<List<BudgetsTableData>, DateTime>((ref, date) {
  final dao = ref.watch(budgetDaoProvider);
  return dao.watchAllBudgets(date.month, date.year);
});

final budgetActionsProvider = Provider<BudgetActions>((ref) {
  final budgetDao = ref.watch(budgetDaoProvider);
  return BudgetActions(budgetDao);
});

final budgetSummaryProvider =
    StreamProvider.family<List<BudgetWithCategory>, DateTime>(
        (ref, date) async* {
  final budgetDao = ref.watch(budgetDaoProvider);
  final categoryDao = ref.watch(categoryDaoProvider);
  final transactionDao = ref.watch(transactionDaoProvider);

  final startOfMonth = DateTime(date.year, date.month, 1);
  final endOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59);

  await for (final _ in transactionDao.watchTransactionsByDateRange(
      startOfMonth, endOfMonth)) {
    final budgets = await budgetDao.getAllBudgets(date.month, date.year);
    final categories = await categoryDao.getAllCategories();
    final transactions = await transactionDao.getTransactionsByDateRange(
      startOfMonth,
      endOfMonth,
    );

    if (budgets.isEmpty) {
      yield [];
      continue;
    }

    final expenseByCategory = <String, int>{};
    for (final t in transactions) {
      if (t.type == 'expense' && t.categoryId != null) {
        expenseByCategory[t.categoryId!] =
            (expenseByCategory[t.categoryId!] ?? 0) + t.amount;
      }
    }

    final result = <BudgetWithCategory>[];

    for (final budget in budgets) {
      final matchIndex = categories.indexWhere((c) => c.id == budget.categoryId);
      if (matchIndex == -1) continue;
      final category = categories[matchIndex];

      final spent = expenseByCategory[budget.categoryId] ?? 0;
      final remaining = budget.amount - spent;
      final percentage =
          budget.amount > 0 ? (spent / budget.amount) * 100 : 0.0;

      result.add(BudgetWithCategory(
        budgetId: budget.id,
        categoryId: budget.categoryId,
        categoryName: category.name,
        categoryIcon: category.icon,
        categoryColor: category.color,
        amount: budget.amount,
        month: budget.month,
        year: budget.year,
        spent: spent,
        remaining: remaining,
        percentage: percentage.clamp(0.0, 100.0).toDouble(),
      ));
    }

    yield result;
  }
});

class BudgetActions {
  final BudgetDao _budgetDao;

  BudgetActions(this._budgetDao);

  Future<void> addBudget({
    required String categoryId,
    required int amount,
    required int month,
    required int year,
  }) async {
    final now = DateTime.now();
    final budget = BudgetsTableCompanion.insert(
      id: IdGenerator.generate(),
      categoryId: categoryId,
      amount: amount,
      month: month,
      year: year,
      createdAt: now,
      updatedAt: now,
    );

    await _budgetDao.insertBudget(budget);
  }

  Future<void> updateBudget({
    required String id,
    required String categoryId,
    required int amount,
    required int month,
    required int year,
  }) async {
    final existing = await _budgetDao.getBudgetById(id);
    if (existing == null) return;

    final updated = existing.copyWith(
      categoryId: categoryId,
      amount: amount,
      month: month,
      year: year,
      updatedAt: DateTime.now(),
    );

    await _budgetDao.updateBudget(updated);
  }

  Future<void> deleteBudget(String id) async {
    await _budgetDao.deleteBudget(id);
  }

  Future<int> rollForwardBudgets({
    required int fromMonth,
    required int fromYear,
    required int toMonth,
    required int toYear,
  }) async {
    return await _budgetDao.copyBudgetsToMonth(
      fromMonth: fromMonth,
      fromYear: fromYear,
      toMonth: toMonth,
      toYear: toYear,
    );
  }
}

final autoRollForwardProvider = FutureProvider<int>((ref) async {
  final budgetDao = ref.watch(budgetDaoProvider);
  final now = DateTime.now();
  final currentMonth = now.month;
  final currentYear = now.year;

  final hasCurrent = await budgetDao.hasBudgets(currentMonth, currentYear);
  if (hasCurrent) return 0;

  final prevMonth = currentMonth == 1 ? 12 : currentMonth - 1;
  final prevYear = currentMonth == 1 ? currentYear - 1 : currentYear;
  final hasPrevious = await budgetDao.hasBudgets(prevMonth, prevYear);
  if (!hasPrevious) return 0;

  final copied = await budgetDao.copyBudgetsToMonth(
    fromMonth: prevMonth,
    fromYear: prevYear,
    toMonth: currentMonth,
    toYear: currentYear,
  );

  return copied;
});
