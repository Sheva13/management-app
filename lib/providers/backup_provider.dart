import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/backup_service.dart';
import '../core/services/backup_worker.dart';

enum BackupStatus { idle, backingUp, success, error }

final backupFrequencyProvider =
    StateNotifierProvider<BackupFrequencyNotifier, String>((ref) {
  return BackupFrequencyNotifier();
});

class BackupFrequencyNotifier extends StateNotifier<String> {
  BackupFrequencyNotifier() : super('off') {
    _loadFrequency();
  }

  Future<void> _loadFrequency() async {
    final frequency = await BackupService.getBackupFrequency();
    state = frequency;
  }

  Future<void> setFrequency(String frequency) async {
    state = frequency;
    await BackupService.setBackupFrequency(frequency);
    await BackupWorker.scheduleBackup(frequency);
  }
}

final lastBackupTimeProvider =
    StateNotifierProvider<LastBackupTimeNotifier, DateTime?>((ref) {
  return LastBackupTimeNotifier();
});

class LastBackupTimeNotifier extends StateNotifier<DateTime?> {
  LastBackupTimeNotifier() : super(null) {
    _loadLastBackupTime();
  }

  Future<void> _loadLastBackupTime() async {
    final time = await BackupService.getLastBackupTime();
    state = time;
  }

  Future<void> refresh() async {
    final time = await BackupService.getLastBackupTime();
    state = time;
  }
}

final backupStatusProvider =
    StateNotifierProvider<BackupStatusNotifier, BackupStatus>((ref) {
  return BackupStatusNotifier(ref);
});

class BackupStatusNotifier extends StateNotifier<BackupStatus> {
  final Ref ref;

  BackupStatusNotifier(this.ref) : super(BackupStatus.idle);

  Future<bool> runBackup() async {
    state = BackupStatus.backingUp;

    final success = await BackupService.runBackup();

    state = success ? BackupStatus.success : BackupStatus.error;

    if (success) {
      await ref.read(lastBackupTimeProvider.notifier).refresh();
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) state = BackupStatus.idle;
    });

    return success;
  }

  Future<bool> restoreFromFile(File file) async {
    state = BackupStatus.backingUp;

    final success = await BackupService.restoreFromFile(file);

    state = success ? BackupStatus.success : BackupStatus.error;

    return success;
  }
}

final latestBackupProvider = FutureProvider<File?>((ref) async {
  return await BackupService.getLatestBackup();
});

final allBackupsProvider = FutureProvider<List<File>>((ref) async {
  return await BackupService.getAllBackups();
});
