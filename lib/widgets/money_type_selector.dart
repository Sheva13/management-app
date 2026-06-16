import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/utils/currency_formatter.dart';

class MoneyTypeSelector extends StatefulWidget {
  final int totalEMoney;
  final int totalCash;
  final Map<String, int> emoneyBreakdown;
  final Map<String, int> cashBreakdown;
  final ValueChanged<bool>? onTypeChanged;
  final VoidCallback? onTapEMoney;
  final VoidCallback? onTapCash;

  const MoneyTypeSelector({
    super.key,
    required this.totalEMoney,
    required this.totalCash,
    this.emoneyBreakdown = const {},
    this.cashBreakdown = const {},
    this.onTypeChanged,
    this.onTapEMoney,
    this.onTapCash,
  });

  @override
  State<MoneyTypeSelector> createState() => _MoneyTypeSelectorState();
}

class _MoneyTypeSelectorState extends State<MoneyTypeSelector> {
  bool _showEMoney = true;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoRotation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRotation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _showEMoney = !_showEMoney;
          _currentIndex = _showEMoney ? 0 : 1;
        });
        widget.onTypeChanged?.call(_showEMoney);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: _showEMoney
                    ? const Offset(-1, 0)
                    : const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: _showEMoney
              ? _buildEMoneyCard(key: const ValueKey('emoney'))
              : _buildCashCard(key: const ValueKey('cash')),
        ),
        const SizedBox(height: AppSizes.paddingSm),
        _buildIndicators(),
      ],
    );
  }

  Widget _buildEMoneyCard({Key? key}) {
    return GestureDetector(
      onTap: widget.onTapEMoney,
      child: Container(
        key: key,
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        decoration: BoxDecoration(
          gradient: AppColors.mainGradient,
          borderRadius: BorderRadius.circular(AppSizes.moneyTypeCardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'E-Money',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingSm),
          Text(
            CurrencyFormatter.formatRupiah(widget.totalEMoney),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (widget.emoneyBreakdown.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingMd),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.emoneyBreakdown.entries.map<Widget>((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${entry.key}: ${CurrencyFormatter.formatCompact(entry.value)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    ),
    );
  }

  Widget _buildCashCard({Key? key}) {
    return GestureDetector(
      onTap: widget.onTapCash,
      child: Container(
        key: key,
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        decoration: BoxDecoration(
          gradient: AppColors.greenGradient,
          borderRadius: BorderRadius.circular(AppSizes.moneyTypeCardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenDark.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.payments_rounded,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Cash',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingSm),
          Text(
            CurrencyFormatter.formatRupiah(widget.totalCash),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (widget.cashBreakdown.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingMd),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.cashBreakdown.entries.map<Widget>((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${entry.key}: ${CurrencyFormatter.formatCompact(entry.value)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.greenPrimary
                : AppColors.textSecondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
