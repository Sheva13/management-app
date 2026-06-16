import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/budget_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/database_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/toast_notification.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  final String? budgetId;

  const AddBudgetScreen({super.key, this.budgetId});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String? _selectedCategoryId;
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.budgetId != null) {
      _isEditing = true;
      _loadBudgetData();
    }
  }

  Future<void> _loadBudgetData() async {
    final db = ref.read(databaseProvider);
    final budgets = await db.budgetDao.getAllBudgets(
      DateTime.now().month,
      DateTime.now().year,
    );
    final budget = budgets.firstWhere(
      (b) => b.id == widget.budgetId,
      orElse: () => throw Exception('Budget not found'),
    );

    setState(() {
      _selectedCategoryId = budget.categoryId;
      _amountController.text = budget.amount.toString();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(_isEditing ? AppStrings.editBudget : AppStrings.addBudget),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryDropdown(categoriesAsync),
              const SizedBox(height: AppSizes.paddingLg),
              _buildAmountField(),
              const SizedBox(height: AppSizes.paddingXl),
              GradientButton(
                text: _isEditing ? AppStrings.save : AppStrings.save,
                isLoading: _isLoading,
                onPressed: _saveBudget,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(AsyncValue categoriesAsync) {
    return categoriesAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (categories) {
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          decoration: const InputDecoration(
            labelText: AppStrings.category,
          ),
          items: categories.map<DropdownMenuItem<String>>((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Pilih kategori';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildAmountField() {
    return CustomTextField(
      label: AppStrings.budgetLimit,
      prefixText: 'Rp ',
      controller: _amountController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan nominal anggaran';
        }
        final amount = CurrencyFormatter.parseRupiah(value);
        if (amount <= 0) {
          return 'Nominal harus lebih dari 0';
        }
        return null;
      },
    );
  }

  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ToastNotification.error(context, 'Pilih kategori');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = CurrencyFormatter.parseRupiah(_amountController.text);
      final now = DateTime.now();
      final monthKey = DateTime(now.year, now.month, 1);

      if (_isEditing) {
        await ref.read(budgetActionsProvider).updateBudget(
              id: widget.budgetId!,
              categoryId: _selectedCategoryId!,
              amount: amount,
              month: now.month,
              year: now.year,
            );
      } else {
        await ref.read(budgetActionsProvider).addBudget(
              categoryId: _selectedCategoryId!,
              amount: amount,
              month: now.month,
              year: now.year,
            );
      }

      if (mounted) {
        ref.invalidate(budgetSummaryProvider(monthKey));
        ref.invalidate(allBudgetsProvider(monthKey));
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
