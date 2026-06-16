import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

class BackupService {
  static Future<String> getDatabasePath() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return p.join(dbFolder.path, 'finansial_ku.sqlite');
  }

  static Future<String> backupDatabase() async {
    try {
      final dbPath = await getDatabasePath();
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        throw Exception('Database file not found');
      }

      final timestamp = DateTime.now();
      final fileName =
          'finansial_ku_backup_${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}${timestamp.second.toString().padLeft(2, '0')}.db';

      final backupDir = await getApplicationDocumentsDirectory();
      final backupFile = File(p.join(backupDir.path, 'backups'));
      await backupDir.create(recursive: true);

      final backupPath = p.join(backupDir.path, 'backups', fileName);
      await dbFile.copy(backupPath);

      return backupPath;
    } catch (e) {
      throw Exception('Failed to backup database: $e');
    }
  }

  static Future<void> shareBackup() async {
    try {
      final backupPath = await backupDatabase();
      final backupFile = File(backupPath);

      if (await backupFile.exists()) {
        await Share.shareXFiles(
          [XFile(backupPath)],
          subject: 'FinansialKu Backup',
          text: 'Backup data FinansialKu',
        );
      }
    } catch (e) {
      throw Exception('Failed to share backup: $e');
    }
  }

  static Future<bool> restoreDatabase(String backupPath) async {
    try {
      final backupFile = File(backupPath);

      if (!await backupFile.exists()) {
        throw Exception('Backup file not found');
      }

      final dbPath = await getDatabasePath();
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        await dbFile.delete();
      }

      await backupFile.copy(dbPath);

      return true;
    } catch (e) {
      throw Exception('Failed to restore database: $e');
    }
  }

  static Future<List<String>> getBackupFiles() async {
    try {
      final backupDir = await getApplicationDocumentsDirectory();
      final backupsPath = p.join(backupDir.path, 'backups');
      final backupsDirectory = Directory(backupsPath);

      if (!await backupsDirectory.exists()) {
        return [];
      }

      final files = await backupsDirectory.list().toList();
      final backupFiles = files
          .whereType<File>()
          .where((file) => file.path.endsWith('.db'))
          .map((file) => file.path)
          .toList();

      backupFiles.sort((a, b) => b.compareTo(a));

      return backupFiles;
    } catch (e) {
      return [];
    }
  }
}
