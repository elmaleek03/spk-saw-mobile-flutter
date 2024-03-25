import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomStyles {
  final Color? textColor;

  const CustomStyles({
    this.textColor,
  });

  static TextStyle appBarTextStyle({
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 18,
    Color? color, // Change Color to Color?
  }) {
    return GoogleFonts.inter(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color ?? Colors.black, // Use provided color or default to black
    );
  }
}

class NumberFormatter {
  static String formatValue(int value) {
    return NumberFormat.decimalPattern().format(value.floor());
  }

  static String formatValueTwo(double value) {
    return NumberFormat.decimalPattern().format(value.floor());
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,##0", "id_ID");
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = 'Rp. ' + f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
