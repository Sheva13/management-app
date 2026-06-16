import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/services/backup_service.dart';
import 'core/services/backup_worker.dart';
import 'screens/settings/widgets/restore_confirm_dialog.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  try {
    await initializeDateFormatting('id_ID');
  } catch (_) {}

  File? latestBackup;

  if (Platform.isAndroid) {
    try {
      await BackupWorker.initialize();
    } catch (_) {}

    try {
      final hasPermission = await BackupService.requestStoragePermission();
      if (hasPermission) {
        latestBackup = await BackupService.getLatestBackup();
      }
    } catch (_) {}

    try {
      final frequency = await BackupService.getBackupFrequency();
      if (frequency != 'off') {
        await BackupWorker.scheduleBackup(frequency);
      }
    } catch (_) {}
  }

  runApp(
    ProviderScope(
      child: FinansialKuRoot(latestBackup: latestBackup),
    ),
  );
}

class FinansialKuRoot extends ConsumerStatefulWidget {
  final File? latestBackup;

  const FinansialKuRoot({super.key, this.latestBackup});

  @override
  ConsumerState<FinansialKuRoot> createState() => _FinansialKuRootState();
}

class _FinansialKuRootState extends ConsumerState<FinansialKuRoot> {
  bool _showRestoreDialog = false;

  @override
  void initState() {
    super.initState();
    if (widget.latestBackup != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRestoreDialog = true;
        setState(() {});
      });
    }
  }

  void _onRestore() async {
    setState(() {
      _showRestoreDialog = false;
    });

    if (widget.latestBackup != null) {
      final success = await BackupService.restoreFromFile(widget.latestBackup!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restore berhasil! Aplikasi akan ditutup.'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {});
          }
        });
      }
    }
  }

  void _onSkipRestore() {
    setState(() {
      _showRestoreDialog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinansialKu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: Stack(
        children: [
          const FinansialKuApp(),
          if (_showRestoreDialog && widget.latestBackup != null)
            Material(
              color: Colors.black54,
              child: Center(
                child: RestoreConfirmDialog(
                  backupFile: widget.latestBackup!,
                  onRestore: _onRestore,
                  onSkip: _onSkipRestore,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
