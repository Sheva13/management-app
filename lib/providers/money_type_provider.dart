import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../database/app_database.dart';
import '../database/daos/money_type_dao.dart';

final moneyTypeDaoProvider = Provider<MoneyTypeDao>((ref) {
  final db = ref.watch(databaseProvider);
  return MoneyTypeDao(db);
});

final allMoneyTypesProvider = StreamProvider<List<MoneyTypesTableData>>((ref) {
  final dao = ref.watch(moneyTypeDaoProvider);
  return dao.watchAllMoneyTypes();
});

final moneyTypeByIdProvider =
    FutureProvider.family<MoneyTypesTableData?, String>((ref, id) async {
  final dao = ref.watch(moneyTypeDaoProvider);
  return dao.getMoneyTypeById(id);
});
