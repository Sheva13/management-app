import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_strings.dart';

class NoteInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const NoteInput({
    super.key,
    this.controller,
    this.hintText,
    this.maxLines = 3,
    this.onChanged,
  });

  @override
  State<NoteInput> createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Catatan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
            border: Border.all(
              color: _isFocused ? AppColors.greenPrimary : AppColors.border,
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
            onTap: () {
              setState(() {
                _isFocused = true;
              });
            },
            onEditingComplete: () {
              setState(() {
                _isFocused = false;
              });
            },
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText ?? AppStrings.noteHint,
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd,
                vertical: AppSizes.paddingMd,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
