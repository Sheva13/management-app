import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/services/backup_service.dart';
import '../../../providers/backup_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'restore_confirm_dialog.dart';

class BackupSettingsSection extends ConsumerWidget {
  const BackupSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequency = ref.watch(backupFrequencyProvider);
    final lastBackup = ref.watch(lastBackupTimeProvider);
    final backupStatus = ref.watch(backupStatusProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.paddingSm,
            bottom: AppSizes.paddingSm,
          ),
          child: Text(
            'Backup & Restore',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildFrequencyTile(
                icon: Icons.schedule_rounded,
                title: 'Jadwal Backup Otomatis',
                frequency: frequency,
                onChanged: (value) {
                  ref.read(backupFrequencyProvider.notifier).setFrequency(value);
                },
              ),
              const Divider(height: 1, indent: 56),
              _buildLastBackupInfo(lastBackup),
              const Divider(height: 1, indent: 56),
              _buildActionTile(
                icon: Icons.backup_rounded,
                title: 'Backup Sekarang',
                subtitle: backupStatus == BackupStatus.backingUp
                    ? 'Sedang backup...'
                    : null,
                isLoading: backupStatus == BackupStatus.backingUp,
                onTap: backupStatus == BackupStatus.backingUp
                    ? null
                    : () => _handleBackupNow(context, ref),
              ),
              const Divider(height: 1, indent: 56),
              _buildActionTile(
                icon: Icons.restore_rounded,
                title: 'Restore Data',
                subtitle: 'Pilih file backup',
                onTap: () => _handleRestore(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyTile({
    required IconData icon,
    required String title,
    required String frequency,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingSm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.textPrimary),
          const SizedBox(width: AppSizes.paddingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFrequencyChip(
                      label: 'Mati',
                      value: 'off',
                      isSelected: frequency == 'off',
                      onTap: () => onChanged('off'),
                    ),
                    _buildFrequencyChip(
                      label: 'Mingguan',
                      value: 'weekly',
                      isSelected: frequency == 'weekly',
                      onTap: () => onChanged('weekly'),
                    ),
                    _buildFrequencyChip(
                      label: 'Bulanan',
                      value: 'monthly',
                      isSelected: frequency == 'monthly',
                      onTap: () => onChanged('monthly'),
                    ),
                    _buildFrequencyChip(
                      label: 'Tahunan',
                      value: 'yearly',
                      isSelected: frequency == 'yearly',
                      onTap: () => onChanged('yearly'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyChip({
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenPrimary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.greenPrimary
                : AppColors.textSecondary.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? AppColors.greenPrimary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildLastBackupInfo(DateTime? lastBackup) {
    String subtitle;
    if (lastBackup != null) {
      final now = DateTime.now();
      final difference = now.difference(lastBackup);

      if (difference.inMinutes < 60) {
        subtitle = '${difference.inMinutes} menit yang lalu';
      } else if (difference.inHours < 24) {
        subtitle = '${difference.inHours} jam yang lalu';
      } else {
        subtitle = DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(lastBackup);
      }
    } else {
      subtitle = 'Belum pernah backup';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingMd,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time_rounded,
            size: 24,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: AppSizes.paddingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Backup Terakhir',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isLoading = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingMd,
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.textPrimary),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.greenPrimary,
                  ),
                ),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBackupNow(BuildContext context, WidgetRef ref) async {
    final hasPermission = await BackupService.requestStoragePermission();
    if (!hasPermission && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin storage diperlukan untuk backup'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await ref.read(backupStatusProvider.notifier).runBackup();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Backup berhasil disimpan' : 'Backup gagal',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleRestore(BuildContext context, WidgetRef ref) async {
    try {
      final hasPermission = await BackupService.requestStoragePermission();
      if (!hasPermission && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin storage diperlukan untuk memilih file'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.first;
      if (pickedFile.path == null) return;
      if (!pickedFile.path!.endsWith('.sqlite')) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File harus berekstensi .sqlite'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      final file = File(pickedFile.path!);
      if (!await file.exists()) return;

      if (!context.mounted) return;

      RestoreConfirmDialog.show(
        context,
        backupFile: file,
        onRestore: () async {
          final success =
              await ref.read(backupStatusProvider.notifier).restoreFromFile(file);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? 'Restore berhasil! Aplikasi akan ditutup.'
                      : 'Restore gagal',
                ),
                backgroundColor: success ? AppColors.success : AppColors.error,
              ),
            );

            if (success) {
              Future.delayed(const Duration(seconds: 2), () {
                SystemNavigator.pop();
              });
            }
          }
        },
        onSkip: () {},
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memilih file backup'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
