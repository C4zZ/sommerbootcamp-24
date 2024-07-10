import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

class QuantityInputField extends StatefulWidget {
  const QuantityInputField({
    required this.onQuantityChanged,
    super.key,
    this.initVal = 1,
    this.qtyStyle = QtyStyle.classic,
  });

  final int initVal;
  final void Function(dynamic value) onQuantityChanged;
  final QtyStyle qtyStyle;

  @override
  State<QuantityInputField> createState() => _QuantityInputFieldState();
}

class _QuantityInputFieldState extends State<QuantityInputField> {
  late int value;

  @override
  void initState() {
    value = widget.initVal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputQty.int(
      maxVal: 99,
      initVal: value,
      onQtyChanged: widget.onQuantityChanged,
      qtyFormProps: const QtyFormProps(
        enableTyping: false,
      ),
      decoration: QtyDecorationProps(
        qtyStyle: widget.qtyStyle,
        border: OutlineInputBorder(
          borderSide:
          BorderSide(color: Colors.grey[500]!),
          borderRadius: const BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        btnColor: theme.primaryColor,
        // isCollapsed: false,
        constraints: const BoxConstraints(
          minHeight: double.infinity,
        ),
        minusButtonConstrains: const BoxConstraints(
          minHeight: double.infinity,
        ),
        plusButtonConstrains: const BoxConstraints(
          minHeight: double.infinity,
        ),
      ),
    );
  }
}
