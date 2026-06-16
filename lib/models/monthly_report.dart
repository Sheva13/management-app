import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_report.freezed.dart';
part 'monthly_report.g.dart';

@freezed
class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    required int year,
    required int month,
    required int totalIncome,
    required int totalExpense,
    required Map<String, int> incomeByCategory,
    required Map<String, int> expenseByCategory,
    required Map<String, int> incomeByPlatform,
    required Map<String, int> expenseByPlatform,
  }) = _MonthlyReport;

  factory MonthlyReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportFromJson(json);
}
