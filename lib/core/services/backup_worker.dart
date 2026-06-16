import 'package:workmanager/workmanager.dart';
import 'backup_service.dart';
import 'budget_worker.dart';

const String backupTaskName = 'finansial_ku_backup_task';
const String backupCallbackKey = 'finansial_ku_backup_callback';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case backupCallbackKey:
        await BackupService.runBackup();
        break;
      case budgetCallbackKey:
        final now = DateTime.now();
        if (now.day == 1) {
          await BudgetWorkerService.runRollForward();
        }
        break;
    }
    return true;
  });
}

class BackupWorker {
  static final Workmanager _workmanager = Workmanager();

  static Future<void> initialize() async {
    await _workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> scheduleBackup(String frequency) async {
    await _workmanager.cancelByUniqueName(backupTaskName);

    if (frequency == 'off') return;

    Duration? interval;
    switch (frequency) {
      case 'weekly':
        interval = const Duration(hours: 168);
        break;
      case 'monthly':
        interval = const Duration(hours: 720);
        break;
      case 'yearly':
        interval = const Duration(hours: 8760);
        break;
      default:
        return;
    }

    await _workmanager.registerPeriodicTask(
      backupTaskName,
      backupCallbackKey,
      frequency: interval,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.exponential,
      initialDelay: interval,
    );
  }

  static Future<void> cancelAllBackups() async {
    await _workmanager.cancelAll();
  }

  static Future<void> runBackupNow() async {
    await BackupService.runBackup();
  }
}
