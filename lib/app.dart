import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/glassy_sidebar.dart';
import 'screens/home/home_screen.dart';
import 'screens/transaction/transaction_list_screen.dart';
import 'screens/report/report_screen.dart';
import 'screens/budget/budget_list_screen.dart';
import 'screens/category/category_list_screen.dart';
import 'screens/money_type/money_type_list_screen.dart';
import 'screens/log/transaction_log_screen.dart';
import 'screens/settings/settings_screen.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class FinansialKuApp extends ConsumerStatefulWidget {
  const FinansialKuApp({super.key});

  @override
  ConsumerState<FinansialKuApp> createState() => _FinansialKuAppState();
}

class _FinansialKuAppState extends ConsumerState<FinansialKuApp> {
  bool _sidebarExpanded = false;
  Timer? _autoCloseTimer;
  DateTime? _lastBackPress;

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _expandSidebar() {
    if (_sidebarExpanded) return;
    setState(() => _sidebarExpanded = true);
    _startAutoCloseTimer();
  }

  void _collapseSidebar() {
    if (!_sidebarExpanded) return;
    _autoCloseTimer?.cancel();
    setState(() => _sidebarExpanded = false);
  }

  void _toggleSidebar() {
    if (_sidebarExpanded) {
      _collapseSidebar();
    } else {
      _expandSidebar();
    }
  }

  void _startAutoCloseTimer() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = Timer(const Duration(seconds: 5), () {
      _collapseSidebar();
    });
  }

  void _handleBack() {
    final currentIndex = ref.read(currentIndexProvider);

    if (currentIndex != 0) {
      ref.read(currentIndexProvider.notifier).state = 0;
    } else {
      final now = DateTime.now();
      if (_lastBackPress != null &&
          now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
        SystemNavigator.pop();
      } else {
        _lastBackPress = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tekan sekali lagi untuk keluar'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _collapseSidebar,
              child: _buildPage(currentIndex),
            ),
            Positioned.fill(
              child: RadialSidebar(
                currentIndex: currentIndex,
                isExpanded: _sidebarExpanded,
                onToggle: _toggleSidebar,
                onTap: (index) {
                  ref.read(currentIndexProvider.notifier).state = index;
                  _collapseSidebar();
                },
                icons: const [
                  SidebarIconData(
                    icon: Icons.home_rounded,
                    tooltip: 'Beranda',
                  ),
                  SidebarIconData(
                    icon: Icons.account_balance_wallet_rounded,
                    tooltip: 'Transaksi',
                  ),
                  SidebarIconData(
                    icon: Icons.bar_chart_rounded,
                    tooltip: 'Laporan',
                  ),
                  SidebarIconData(
                    icon: Icons.savings_rounded,
                    tooltip: 'Budget',
                  ),
                  SidebarIconData(
                    icon: Icons.category_rounded,
                    tooltip: 'Kategori',
                  ),
                  SidebarIconData(
                    icon: Icons.credit_card_rounded,
                    tooltip: 'Jenis Uang',
                  ),
                  SidebarIconData(
                    icon: Icons.receipt_long_rounded,
                    tooltip: 'Log Keuangan',
                  ),
                  SidebarIconData(
                    icon: Icons.settings_rounded,
                    tooltip: 'Pengaturan',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const TransactionListScreen();
      case 2:
        return const ReportScreen();
      case 3:
        return const BudgetListScreen();
      case 4:
        return const CategoryListScreen();
      case 5:
        return const MoneyTypeListScreen();
      case 6:
        return const TransactionLogScreen();
      case 7:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }
}
