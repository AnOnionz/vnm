import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:fms/core/mixins/extension/string_ext.dart';

final kNumberFormater = CurrencyTextInputFormatter.currency(
  symbol: '',
);

class NumberFormater extends TextInputFormatter {
  const NumberFormater(
      {this.isDecimal = true,
      this.decimalDegits = 2,
      this.minValue = 0,
      this.maxValue = 9999999999,
      this.onChanged});

  final bool isDecimal;
  final int decimalDegits;
  final num minValue;
  final num maxValue;
  final void Function(String? value)? onChanged;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!isDecimal && newValue.text.contains(',')) return oldValue;

    final truns = newValue.text.split(',');

    final String truncated = truns[0].replaceAll('.', '');
    final String? fractional = truns.length > 1 ? truns.last : null;

    final invalidDecimalDegits =
        fractional != null && fractional.length > decimalDegits;

    var value = truncated.isEmpty
        ? truncated
        : kNumberFormater.formatString(truncated) +
            (fractional != null ? ',$fractional' : '');
    final validValue = value.isEmpty
        ? '0'
        : truncated + (!fractional.isEmptyOrNull ? '.$fractional' : '');

    final invalidMin =
        (isDecimal ? double.parse(validValue) : int.parse(validValue)) <
            minValue;

    final invalidMax =
        (isDecimal ? double.parse(validValue) : int.parse(validValue)) >
            maxValue;
    if ((isDecimal && invalidDecimalDegits) ||
        (!value.isEmptyOrNull && (invalidMin || invalidMax))) {
      value = oldValue.text;
    }
    onChanged?.call(value
        .replaceAll('.', '')
        .replaceAll(',', !fractional.isEmptyOrNull ? '.' : ''));

    return TextEditingValue(
      text: value,
      selection: TextSelection(
        baseOffset: value.length,
        extentOffset: value.length,
      ),
    );
  }
}
