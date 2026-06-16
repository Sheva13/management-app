import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String formatRupiah(int amount) {
    return _rupiahFormat.format(amount);
  }

  static String formatRupiahWithSymbol(int amount) {
    return _rupiahFormat.format(amount);
  }

  static int parseRupiah(String formatted) {
    final cleaned = formatted
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll(' ', '');
    return int.tryParse(cleaned) ?? 0;
  }

  static String formatCompact(int amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}Jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}Rb';
    }
    return amount.toString();
  }
}
