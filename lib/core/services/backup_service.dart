import 'dart:io';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class BackupService {
  static const String _backupFolderName = 'FinansialKu';
  static const String _backupPrefix = 'backup_finansial_ku_';
  static const String _settingsBoxName = 'settings';
  static const String _backupFrequencyKey = 'backup_frequency';
  static const String _lastBackupTimeKey = 'last_backup_time';
  static const int _maxBackups = 6;

  static Future<Directory> getBackupDirectory() async {
    if (Platform.isAndroid) {
      final backupDir = Directory('/storage/emulated/0/Download/$_backupFolderName');
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      return backupDir;
    }
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(appDir.path, _backupFolderName));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  static Future<String> getDatabasePath() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return p.join(dbFolder.path, 'finansial_ku.sqlite');
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.status;
      if (status.isGranted) return true;

      final requestStatus = await Permission.manageExternalStorage.request();
      if (requestStatus.isGranted) return true;

      final fallbackStatus = await Permission.storage.request();
      return fallbackStatus.isGranted;
    }
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> runBackup() async {
    try {
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) return false;

      final dbPath = await getDatabasePath();
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) return false;

      final backupDir = await getBackupDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final backupFileName = '$_backupPrefix$timestamp.sqlite';
      final backupFile = File(p.join(backupDir.path, backupFileName));

      await dbFile.copy(backupFile.path);

      await _cleanupOldBackups(backupDir);
      await _updateLastBackupTime();

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _cleanupOldBackups(Directory backupDir) async {
    final files = await backupDir
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.sqlite'))
        .cast<File>()
        .toList();

    files.sort((a, b) => b.path.compareTo(a.path));

    if (files.length > _maxBackups) {
      for (int i = _maxBackups; i < files.length; i++) {
        await files[i].delete();
      }
    }
  }

  static Future<void> _updateLastBackupTime() async {
    final box = await Hive.openBox(_settingsBoxName);
    await box.put(_lastBackupTimeKey, DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLastBackupTime() async {
    final box = await Hive.openBox(_settingsBoxName);
    final timeStr = box.get(_lastBackupTimeKey) as String?;
    if (timeStr == null) return null;
    return DateTime.tryParse(timeStr);
  }

  static Future<void> setBackupFrequency(String frequency) async {
    final box = await Hive.openBox(_settingsBoxName);
    await box.put(_backupFrequencyKey, frequency);
  }

  static Future<String> getBackupFrequency() async {
    final box = await Hive.openBox(_settingsBoxName);
    return box.get(_backupFrequencyKey, defaultValue: 'off') as String;
  }

  static Future<File?> getLatestBackup() async {
    try {
      final backupDir = await getBackupDirectory();
      if (!await backupDir.exists()) return null;

      final files = await backupDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.sqlite'))
          .cast<File>()
          .toList();

      if (files.isEmpty) return null;

      files.sort((a, b) => b.path.compareTo(a.path));
      return files.first;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> restoreFromFile(File backupFile) async {
    try {
      if (!await backupFile.exists()) return false;

      final dbPath = await getDatabasePath();
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final backupDir = await getBackupDirectory();
        final preRestorePath =
            p.join(backupDir.path, 'pre_restore_$timestamp.sqlite');
        await dbFile.copy(preRestorePath);
      }

      await backupFile.copy(dbPath);

      return true;
    } catch (e) {
      return false;
    }
  }

  static String getBackupFileName() {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '$_backupPrefix$timestamp.sqlite';
  }

  static Future<List<File>> getAllBackups() async {
    try {
      final backupDir = await getBackupDirectory();
      if (!await backupDir.exists()) return [];

      final files = await backupDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.sqlite'))
          .cast<File>()
          .toList();

      files.sort((a, b) => b.path.compareTo(a.path));
      return files;
    } catch (e) {
      return [];
    }
  }
}
