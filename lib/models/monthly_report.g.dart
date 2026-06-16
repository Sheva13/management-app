// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyReportImpl _$$MonthlyReportImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyReportImpl(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      totalIncome: (json['totalIncome'] as num).toInt(),
      totalExpense: (json['totalExpense'] as num).toInt(),
      incomeByCategory: Map<String, int>.from(json['incomeByCategory'] as Map),
      expenseByCategory:
          Map<String, int>.from(json['expenseByCategory'] as Map),
      incomeByPlatform: Map<String, int>.from(json['incomeByPlatform'] as Map),
      expenseByPlatform:
          Map<String, int>.from(json['expenseByPlatform'] as Map),
    );

Map<String, dynamic> _$$MonthlyReportImplToJson(_$MonthlyReportImpl instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'incomeByCategory': instance.incomeByCategory,
      'expenseByCategory': instance.expenseByCategory,
      'incomeByPlatform': instance.incomeByPlatform,
      'expenseByPlatform': instance.expenseByPlatform,
    };
