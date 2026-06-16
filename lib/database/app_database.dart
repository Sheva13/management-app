import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/transactions_table.dart';
import 'tables/categories_table.dart';
import 'tables/money_types_table.dart';
import 'tables/platforms_table.dart';
import 'tables/transaction_logs_table.dart';
import 'tables/budgets_table.dart';
import 'daos/transaction_dao.dart';
import 'daos/category_dao.dart';
import 'daos/money_type_dao.dart';
import 'daos/platform_dao.dart';
import 'daos/log_dao.dart';
import 'daos/budget_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  TransactionsTable,
  CategoriesTable,
  MoneyTypesTable,
  PlatformsTable,
  TransactionLogsTable,
  BudgetsTable,
], daos: [
  TransactionDao,
  CategoryDao,
  MoneyTypeDao,
  PlatformDao,
  LogDao,
  BudgetDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        try {
          if (from < 7) {
            await m.deleteTable('transaction_logs');
            await m.deleteTable('transactions');
            await m.deleteTable('budgets');
            await m.deleteTable('platforms');
            await m.deleteTable('money_types');
            await m.deleteTable('categories');
            await m.createAll();
            await _seedData();
          }
        } catch (e) {
          await m.deleteTable('transaction_logs');
          await m.deleteTable('transactions');
          await m.deleteTable('budgets');
          await m.deleteTable('platforms');
          await m.deleteTable('money_types');
          await m.deleteTable('categories');
          await m.createAll();
          await _seedData();
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _seedData() async {
    final now = DateTime.now();

    await into(moneyTypesTable).insert(MoneyTypesTableCompanion.insert(
      id: 'mt_emoney',
      name: 'eMoney',
      type: 'emoney',
      createdAt: now,
      updatedAt: now,
    ));

    await into(moneyTypesTable).insert(MoneyTypesTableCompanion.insert(
      id: 'mt_cash',
      name: 'Cash',
      type: 'cash',
      createdAt: now,
      updatedAt: now,
    ));

    final platforms = [
      (id: 'plat_dana', name: 'DANA', icon: 'phone_android', color: 0xFF10B981, moneyTypeId: 'mt_emoney'),
      (id: 'plat_gopay', name: 'GoPay', icon: 'account_balance_wallet', color: 0xFF3B82F6, moneyTypeId: 'mt_emoney'),
      (id: 'plat_ovo', name: 'OVO', icon: 'payment', color: 0xFF8B5CF6, moneyTypeId: 'mt_emoney'),
      (id: 'plat_shopeepay', name: 'ShopeePay', icon: 'shopping_bag', color: 0xFFEF4444, moneyTypeId: 'mt_emoney'),
      (id: 'plat_bank', name: 'Bank', icon: 'account_balance', color: 0xFF6B7280, moneyTypeId: 'mt_emoney'),
      (id: 'plat_cash', name: 'Cash Tunai', icon: 'payments', color: 0xFFEF4444, moneyTypeId: 'mt_cash'),
    ];

    for (final p in platforms) {
      await into(platformsTable).insert(PlatformsTableCompanion.insert(
        id: p.id,
        name: p.name,
        icon: p.icon,
        color: p.color,
        moneyTypeId: p.moneyTypeId,
        createdAt: now,
        updatedAt: now,
      ));
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finansial_ku.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
