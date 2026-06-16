// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_with_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetWithCategoryImpl _$$BudgetWithCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetWithCategoryImpl(
      budgetId: json['budgetId'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      categoryIcon: json['categoryIcon'] as String,
      categoryColor: (json['categoryColor'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      spent: (json['spent'] as num).toInt(),
      remaining: (json['remaining'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$BudgetWithCategoryImplToJson(
        _$BudgetWithCategoryImpl instance) =>
    <String, dynamic>{
      'budgetId': instance.budgetId,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'categoryIcon': instance.categoryIcon,
      'categoryColor': instance.categoryColor,
      'amount': instance.amount,
      'month': instance.month,
      'year': instance.year,
      'spent': instance.spent,
      'remaining': instance.remaining,
      'percentage': instance.percentage,
    };
