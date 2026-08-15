import 'package:intl/intl.dart';

String formatMoney(double amount) {
  return NumberFormat('#,###', 'en_US').format(amount).replaceAll(',', ' ');
}
