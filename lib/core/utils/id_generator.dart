import 'package:uuid/uuid.dart';

class IdGenerator {
  IdGenerator._();

  static const _uuid = Uuid();

  static String generate() {
    return _uuid.v4();
  }

  static String generateShort() {
    return _uuid.v4().substring(0, 8);
  }
}
