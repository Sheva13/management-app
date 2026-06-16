import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class RestoreConfirmDialog extends StatelessWidget {
  final File backupFile;
  final VoidCallback onRestore;
  final VoidCallback onSkip;

  const RestoreConfirmDialog({
    super.key,
    required this.backupFile,
    required this.onRestore,
    required this.onSkip,
  });

  static Future<void> show(
    BuildContext context, {
    required File backupFile,
    required VoidCallback onRestore,
    required VoidCallback onSkip,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RestoreConfirmDialog(
        backupFile: backupFile,
        onRestore: onRestore,
        onSkip: onSkip,
      ),
    );
  }

  String _getBackupDate() {
    final fileName = backupFile.path.split('/').last;
    final dateStr = fileName
        .replaceAll('backup_finansial_ku_', '')
        .replaceAll('.sqlite', '');

    try {
      final parts = dateStr.split('_');
      if (parts.length >= 2) {
        final datePart = parts[0];
        final timePart = parts[1];
        final year = int.parse(datePart.substring(0, 4));
        final month = int.parse(datePart.substring(4, 6));
        final day = int.parse(datePart.substring(6, 8));
        final hour = int.parse(timePart.substring(0, 2));
        final minute = int.parse(timePart.substring(2, 4));
        final second = int.parse(timePart.substring(4, 6));

        final dateTime = DateTime(year, month, day, hour, minute, second);
        return DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(dateTime);
      }
    } catch (_) {}

    return 'Unknown date';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restore_rounded,
              color: AppColors.warning,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Restore Backup?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Backup ditemukan: ${_getBackupDate()}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Data saat ini akan diganti dengan data dari backup.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data sebelum restore akan disimpan sebagai backup keamanan.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSkip();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Batal',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onRestore();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Restore',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
