import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/category_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/toast_notification.dart';
import 'add_category_screen.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.categories),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddCategoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (categories) {
          if (categories.isEmpty) {
            return EmptyState(
              icon: Icons.category_rounded,
              title: AppStrings.emptyCategories,
              subtitle: 'Buat kategori untuk mengorganisir transaksi',
              actionText: 'Tambah Kategori',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddCategoryScreen(),
                  ),
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryItem(
                category: category,
                onDelete: () => _showDeleteDialog(context, ref, category),
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddCategoryScreen(
                        category: category,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, category) {
    ConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteCategory,
      message: 'Kategori "${category.name}" akan dihapus permanen.',
      confirmText: 'Hapus',
      onConfirm: () async {
        await ref.read(categoryActionsProvider).deleteCategory(category.id);
        if (context.mounted) {
          ToastNotification.success(context, AppStrings.deletedSuccessfully);
        }
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final dynamic category;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _CategoryItem({
    required this.category,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(category.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.paddingMd),
        margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
        ),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
          padding: const EdgeInsets.all(AppSizes.paddingMd),
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
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(category.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  _getCategoryIcon(category.icon),
                  color: Color(category.color),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSizes.paddingMd),
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'movie':
        return Icons.movie_rounded;
      case 'receipt':
        return Icons.receipt_rounded;
      case 'local_hospital':
        return Icons.local_hospital_rounded;
      case 'school':
        return Icons.school_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }
}
