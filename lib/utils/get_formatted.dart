import 'package:intl/intl.dart';

class GetFormatted {
  static String number(int value) {
    var f = NumberFormat.decimalPattern('id');
    return f.format(value);
  }
}
