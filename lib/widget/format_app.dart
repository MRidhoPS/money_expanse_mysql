import 'package:intl/intl.dart';

dynamic formatCurrency(double value) {
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return formatter.format(value);
}
