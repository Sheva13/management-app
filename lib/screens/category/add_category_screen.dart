import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/category_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/toast_notification.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  final dynamic category;

  const AddCategoryScreen({super.key, this.category});

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String _selectedIcon = 'restaurant';
  Color _selectedColor = AppColors.greenPrimary;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _icons = [
    {'name': 'restaurant', 'icon': Icons.restaurant_rounded},
    {'name': 'directions_car', 'icon': Icons.directions_car_rounded},
    {'name': 'shopping_bag', 'icon': Icons.shopping_bag_rounded},
    {'name': 'movie', 'icon': Icons.movie_rounded},
    {'name': 'receipt', 'icon': Icons.receipt_rounded},
    {'name': 'local_hospital', 'icon': Icons.local_hospital_rounded},
    {'name': 'school', 'icon': Icons.school_rounded},
    {'name': 'more_horiz', 'icon': Icons.more_horiz_rounded},
  ];

  final List<Color> _colors = [
    AppColors.greenPrimary,
    AppColors.redPrimary,
    const Color(0xFF42A5F5),
    const Color(0xFFAB47BC),
    const Color(0xFFFFCA28),
    const Color(0xFFEF5350),
    const Color(0xFF66BB6A),
    const Color(0xFF5C6BC0),
    const Color(0xFF78909C),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category.name;
      _selectedIcon = widget.category.icon;
      _selectedColor = Color(widget.category.color);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          widget.category != null
              ? AppStrings.editCategory
              : AppStrings.addCategory,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Nama Kategori',
                controller: _nameController,
                hint: 'Masukkan nama kategori',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama kategori';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.paddingLg),
              _buildIconSelector(),
              const SizedBox(height: AppSizes.paddingLg),
              _buildColorSelector(),
              const SizedBox(height: AppSizes.paddingXl),
              GradientButton(
                text: AppStrings.save,
                isLoading: _isLoading,
                onPressed: _saveCategory,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ikon',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _icons.map<Widget>((iconData) {
            final isSelected = _selectedIcon == iconData['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = iconData['name'];
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.greenPrimary.withOpacity(0.1)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.greenPrimary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Icon(
                  iconData['icon'],
                  color: isSelected
                      ? AppColors.greenPrimary
                      : AppColors.textSecondary,
                  size: 24,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Warna',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _colors.map<Widget>((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  border: Border.all(
                    color: isSelected ? AppColors.textPrimary : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 24,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.category != null) {
        await ref.read(categoryActionsProvider).updateCategory(
              id: widget.category.id,
              name: _nameController.text,
              icon: _selectedIcon,
              color: _selectedColor.value,
            );
      } else {
        await ref.read(categoryActionsProvider).addCategory(
              name: _nameController.text,
              icon: _selectedIcon,
              color: _selectedColor.value,
            );
      }

      if (mounted) {
        ToastNotification.success(context, AppStrings.savedSuccessfully);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ToastNotification.error(context, 'Gagal menyimpan: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
