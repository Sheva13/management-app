import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/platform_provider.dart';
import '../../providers/money_type_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/toast_notification.dart';

class AddPlatformScreen extends ConsumerStatefulWidget {
  final String? platformId;
  final String moneyTypeId;

  const AddPlatformScreen({
    super.key,
    this.platformId,
    required this.moneyTypeId,
  });

  @override
  ConsumerState<AddPlatformScreen> createState() => _AddPlatformScreenState();
}

class _AddPlatformScreenState extends ConsumerState<AddPlatformScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController();

  String _selectedIcon = 'credit_card';
  Color _selectedColor = AppColors.greenPrimary;
  bool _isLoading = false;
  bool _isEdit = false;

  final List<Map<String, dynamic>> _icons = [
    {'name': 'account_balance_wallet', 'icon': Icons.account_balance_wallet_rounded},
    {'name': 'phone_android', 'icon': Icons.phone_android_rounded},
    {'name': 'payment', 'icon': Icons.payment_rounded},
    {'name': 'shopping_bag', 'icon': Icons.shopping_bag_rounded},
    {'name': 'account_balance', 'icon': Icons.account_balance_rounded},
    {'name': 'credit_card', 'icon': Icons.credit_card_rounded},
    {'name': 'payments', 'icon': Icons.payments_rounded},
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
    _isEdit = widget.platformId != null;
    if (_isEdit) {
      _loadPlatformData();
    }
  }

  Future<void> _loadPlatformData() async {
    final dao = ref.read(platformDaoProvider);
    final platform = await dao.getPlatformById(widget.platformId!);
    if (platform != null && mounted) {
      setState(() {
        _nameController.text = platform.name;
        _selectedIcon = platform.icon;
        _selectedColor = Color(platform.color);
        _initialBalanceController.text = platform.initialBalance.toString();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moneyTypeAsync = ref.watch(moneyTypeByIdProvider(widget.moneyTypeId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          _isEdit ? AppStrings.editPlatform : AppStrings.addPlatform,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              moneyTypeAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
                data: (moneyType) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    decoration: BoxDecoration(
                      color: (moneyType?.type == 'emoney'
                              ? AppColors.greenPrimary
                              : AppColors.redPrimary)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          moneyType?.type == 'emoney'
                              ? Icons.account_balance_wallet_rounded
                              : Icons.payments_rounded,
                          color: moneyType?.type == 'emoney'
                              ? AppColors.greenPrimary
                              : AppColors.redPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Jenis Uang: ${moneyType?.name ?? '-'}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: moneyType?.type == 'emoney'
                                ? AppColors.greenPrimary
                                : AppColors.redPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSizes.paddingLg),
              CustomTextField(
                label: 'Nama Platform',
                controller: _nameController,
                hint: 'Contoh: DANA, GoPay, OVO',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama platform';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.paddingLg),
              _buildInitialBalanceField(),
              const SizedBox(height: AppSizes.paddingLg),
              _buildIconSelector(),
              const SizedBox(height: AppSizes.paddingLg),
              _buildColorSelector(),
              const SizedBox(height: AppSizes.paddingXl),
              GradientButton(
                text: AppStrings.save,
                isLoading: _isLoading,
                onPressed: _savePlatform,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialBalanceField() {
    return CustomTextField(
      label: 'Saldo Awal',
      controller: _initialBalanceController,
      hint: 'Contoh: 500000',
      keyboardType: TextInputType.number,
      prefixText: 'Rp ',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan saldo awal';
        }
        final balance = int.tryParse(value.replaceAll('.', ''));
        if (balance == null) {
          return 'Format angka tidak valid';
        }
        return null;
      },
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

  Future<void> _savePlatform() async {
    if (!_formKey.currentState!.validate()) return;

    final initialBalance = int.tryParse(_initialBalanceController.text.replaceAll('.', '')) ?? 0;

    setState(() => _isLoading = true);

    try {
      if (_isEdit) {
        await ref.read(platformActionsProvider).updatePlatform(
              id: widget.platformId!,
              name: _nameController.text,
              icon: _selectedIcon,
              color: _selectedColor.value,
              moneyTypeId: widget.moneyTypeId,
              initialBalance: initialBalance,
            );
      } else {
        await ref.read(platformActionsProvider).addPlatform(
              name: _nameController.text,
              icon: _selectedIcon,
              color: _selectedColor.value,
              moneyTypeId: widget.moneyTypeId,
              initialBalance: initialBalance,
            );
      }

      if (mounted) {
        ref.invalidate(platformBalancesProvider);
        ref.invalidate(walletProvider);
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
