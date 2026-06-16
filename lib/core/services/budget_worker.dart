import 'package:workmanager/workmanager.dart';
import '../../database/app_database.dart';
import '../../database/daos/budget_dao.dart';

const String budgetTaskName = 'finansial_ku_budget_rollforward';
const String budgetCallbackKey = 'finansial_ku_budget_rollforward_callback';

class BudgetWorkerService {
  static Future<void> runRollForward({bool force = false}) async {
    try {
      final db = AppDatabase();
      final budgetDao = BudgetDao(db);

      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      if (!force && now.day != 1) {
        await db.close();
        return;
      }

      final hasCurrent = await budgetDao.hasBudgets(currentMonth, currentYear);
      if (hasCurrent) {
        await db.close();
        return;
      }

      final prevMonth = currentMonth == 1 ? 12 : currentMonth - 1;
      final prevYear = currentMonth == 1 ? currentYear - 1 : currentYear;
      final hasPrevious = await budgetDao.hasBudgets(prevMonth, prevYear);

      if (hasPrevious) {
        await budgetDao.copyBudgetsToMonth(
          fromMonth: prevMonth,
          fromYear: prevYear,
          toMonth: currentMonth,
          toYear: currentYear,
        );
      }

      await db.close();
    } catch (_) {}
  }
}

class BudgetWorker {
  static final Workmanager _workmanager = Workmanager();

  static Future<void> scheduleMonthlyRollForward() async {
    await _workmanager.cancelByUniqueName(budgetTaskName);

    await _workmanager.registerPeriodicTask(
      budgetTaskName,
      budgetCallbackKey,
      frequency: const Duration(hours: 720),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.exponential,
    );
  }

  static Future<void> cancel() async {
    await _workmanager.cancelByUniqueName(budgetTaskName);
  }
}
