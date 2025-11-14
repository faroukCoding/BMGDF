import 'package:intl/intl.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd - HH:mm').format(date);
  }
  
  static String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} ريال';
  }
  
  static String truncateText(String text, {int maxLength = 50}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}