import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_with_category.freezed.dart';
part 'budget_with_category.g.dart';

@freezed
class BudgetWithCategory with _$BudgetWithCategory {
  const factory BudgetWithCategory({
    required String budgetId,
    required String categoryId,
    required String categoryName,
    required String categoryIcon,
    required int categoryColor,
    required int amount,
    required int month,
    required int year,
    required int spent,
    required int remaining,
    required double percentage,
  }) = _BudgetWithCategory;

  factory BudgetWithCategory.fromJson(Map<String, dynamic> json) =>
      _$BudgetWithCategoryFromJson(json);
}
