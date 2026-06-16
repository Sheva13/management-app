import 'package:drift/drift.dart';

class MigrationStrategyImpl {
  static MigrationStrategy get strategy {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
      beforeOpen: (details) async {},
    );
  }
}
