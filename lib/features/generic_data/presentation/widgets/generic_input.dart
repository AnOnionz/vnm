import 'package:flutter/material.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/constant/format.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';

class GenericInput extends StatefulWidget {
  final GenericType type;
  final String label;
  final String? initValue;
  final num maxValue;
  final num minValue;
  final String? Function(String?)? validator;
  final void Function(String? value) onChanged;
  const GenericInput(
      {super.key,
      required this.label,
      required this.type,
      this.initValue,
      required this.onChanged,
      required this.maxValue,
      required this.minValue,
      this.validator});

  @override
  State<GenericInput> createState() => _GenericInputState();
}

class _GenericInputState extends State<GenericInput> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  late String value;

  Color _color = AppColors.nobel;

  bool get isDecimal => widget.type == GenericType.decimal;

  void updateState() {
    if (_controller.text.isEmpty) {
      setState(() {
        _color = AppColors.nobel;
        value = _controller.text;
      });
    } else {
      setState(() {
        _color = AppColors.primary;
        value = _controller.text;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.initValue.isEmptyOrNull
            ? null
            : isDecimal
                ? widget.initValue!.replaceAll('.', ',')
                : kNumberFormater.formatString(widget.initValue!));
    updateState();
    _controller.addListener(updateState);
  }

  @override
  void dispose() {
    _controller.removeListener(updateState);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.nobel, width: 0.54),
        borderRadius: BorderRadius.circular(8.sqr));
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Expanded(
              child: Text(
            widget.label,
            style:
                context.textTheme.caption2?.copyWith(color: '201A25'.toColor()),
          )),
          Expanded(
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              validator: widget.validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorHeight: 16.8.sp,
              cursorColor: AppColors.nobel,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: [
                NumberFormater(
                  // minValue: widget.minValue,
                  maxValue: widget.maxValue,
                  isDecimal: widget.type == GenericType.decimal,
                  onChanged: (value) {
                    if (value == widget.initValue) return;
                    widget.onChanged(value);
                  },
                )
              ],
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) =>
                  null,
              maxLength: isDecimal ? 16 : 13,
              style: context.textTheme.body2?.copyWith(color: _color),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.h),
                // hintText: '0',
                // hintStyle:
                //     context.textTheme.body2?.copyWith(color: AppColors.nobel),
                enabledBorder: border.copyWith(
                    borderSide: border.borderSide.copyWith(color: _color)),
                focusedBorder: border.copyWith(
                    borderSide:
                        border.borderSide.copyWith(color: AppColors.primary)),
                focusedErrorBorder: border.copyWith(
                    borderSide:
                        border.borderSide.copyWith(color: AppColors.red)),
                errorBorder: border.copyWith(
                    borderSide:
                        border.borderSide.copyWith(color: AppColors.red)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
