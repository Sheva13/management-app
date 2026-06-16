import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/money_type_provider.dart';
import '../../providers/platform_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/note_input.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/toast_notification.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _transactionType = 'expense';
  String? _selectedCategoryId;
  String? _selectedMoneyTypeId;
  String? _selectedPlatformId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final moneyTypesAsync = ref.watch(allMoneyTypesProvider);
    final platformsAsync = ref.watch(allPlatformsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(AppStrings.addTransaction),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTransactionTypeSelector(),
              const SizedBox(height: AppSizes.paddingLg),
              _buildAmountField(),
              if (_transactionType == 'expense') ...[
                const SizedBox(height: AppSizes.paddingLg),
                _buildCategoryDropdown(categoriesAsync),
              ],
              const SizedBox(height: AppSizes.paddingLg),
              _buildMoneyTypeSelector(moneyTypesAsync),
              if (_selectedMoneyTypeId != null) ...[
                const SizedBox(height: AppSizes.paddingLg),
                _buildPlatformDropdown(platformsAsync),
              ],
              const SizedBox(height: AppSizes.paddingLg),
              NoteInput(controller: _noteController),
              const SizedBox(height: AppSizes.paddingLg),
              _buildDatePicker(),
              const SizedBox(height: AppSizes.paddingXl),
              GradientButton(
                text: AppStrings.save,
                isLoading: _isLoading,
                onPressed: _saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Transaksi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _transactionType = 'expense';
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _transactionType == 'expense'
                        ? AppColors.redPrimary.withOpacity(0.1)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: _transactionType == 'expense'
                          ? AppColors.redPrimary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: _transactionType == 'expense'
                            ? AppColors.redPrimary
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.expense,
                        style: TextStyle(
                          color: _transactionType == 'expense'
                              ? AppColors.redPrimary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.paddingSm),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _transactionType = 'income';
                  _selectedCategoryId = null;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _transactionType == 'income'
                        ? AppColors.greenPrimary.withOpacity(0.1)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: _transactionType == 'income'
                          ? AppColors.greenPrimary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: _transactionType == 'income'
                            ? AppColors.greenPrimary
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.income,
                        style: TextStyle(
                          color: _transactionType == 'income'
                              ? AppColors.greenPrimary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return CustomTextField(
      label: AppStrings.nominal,
      prefixText: 'Rp ',
      controller: _amountController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan nominal';
        }
        final amount = CurrencyFormatter.parseRupiah(value);
        if (amount <= 0) {
          return 'Nominal harus lebih dari 0';
        }
        return null;
      },
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

  Widget _buildMoneyTypeSelector(AsyncValue moneyTypesAsync) {
    return moneyTypesAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (moneyTypes) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.moneyType,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: moneyTypes.map<Widget>((moneyType) {
                final isSelected = _selectedMoneyTypeId == moneyType.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMoneyTypeId = moneyType.id;
                      _selectedPlatformId = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.greenPrimary.withOpacity(0.1)
                          : const Color(0xFFF3F4F6),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.greenPrimary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      moneyType.name,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.greenPrimary
                            : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlatformDropdown(AsyncValue platformsAsync) {
    return platformsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (platforms) {
        final filteredPlatforms = platforms
            .where((p) => p.moneyTypeId == _selectedMoneyTypeId)
            .toList();

        if (filteredPlatforms.isEmpty) {
          return const SizedBox.shrink();
        }

        return DropdownButtonFormField<String>(
          value: _selectedPlatformId,
          decoration: const InputDecoration(
            labelText: AppStrings.platform,
          ),
          items: filteredPlatforms.map<DropdownMenuItem<String>>((platform) {
            return DropdownMenuItem<String>(
              value: platform.id,
              child: Text(platform.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPlatformId = value;
            });
          },
        );
      },
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.date,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingSm + 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '${_selectedDate.day} ${_selectedDate.month} ${_selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.greenPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_transactionType == 'expense' && _selectedCategoryId == null) {
      ToastNotification.error(context, 'Pilih kategori');
      return;
    }
    if (_selectedMoneyTypeId == null) {
      ToastNotification.error(context, 'Pilih jenis uang');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = CurrencyFormatter.parseRupiah(_amountController.text);

      await ref.read(transactionActionsProvider).addTransaction(
            amount: amount,
            type: _transactionType,
            categoryId: _selectedCategoryId,
            moneyTypeId: _selectedMoneyTypeId!,
            platformId: _selectedPlatformId,
            note: _noteController.text.isNotEmpty ? _noteController.text : null,
            date: _selectedDate,
          );

      await ref.read(walletProvider.notifier).refresh();
      ref.invalidate(platformBalancesProvider);

      if (mounted) {
        ToastNotification.success(context, AppStrings.savedSuccessfully);
        _resetForm();
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

  void _resetForm() {
    _amountController.clear();
    _noteController.clear();
    setState(() {
      _selectedCategoryId = null;
      _selectedMoneyTypeId = null;
      _selectedPlatformId = null;
      _selectedDate = DateTime.now();
    });
  }
}
