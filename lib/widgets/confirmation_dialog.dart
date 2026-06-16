import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Hapus',
    this.cancelText = 'Batal',
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = true,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Hapus',
    String cancelText = 'Batal',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = true,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.greenPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDestructive
                    ? Icons.warning_rounded
                    : Icons.help_outline_rounded,
                color: isDestructive ? AppColors.error : AppColors.greenPrimary,
                size: 24,
              ),
            ),
            const SizedBox(height: AppSizes.paddingMd),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingSm),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingLg),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    child: Container(
                      height: AppSizes.buttonHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius:
                            BorderRadius.circular(AppSizes.buttonRadius),
                      ),
                      child: Center(
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSm),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    child: Container(
                      height: AppSizes.buttonHeight,
                      decoration: BoxDecoration(
                        gradient: isDestructive
                            ? AppColors.redGradient
                            : AppColors.mainGradient,
                        borderRadius:
                            BorderRadius.circular(AppSizes.buttonRadius),
                      ),
                      child: Center(
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
