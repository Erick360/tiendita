import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityInput extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onChanged;

  const QuantityInput({
    Key? key,
    required this.initialQuantity,
    required this.onChanged
  }) : super(key: key);

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuantity.toString());
  }

  @override
  void didUpdateWidget(QuantityInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuantity != oldWidget.initialQuantity &&
        int.tryParse(_controller.text) != widget.initialQuantity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.initialQuantity.toString();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 40,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
        onTap: () => _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length
        ),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          final newQuantity = int.tryParse(value);
          if (newQuantity != null && newQuantity >= 0) {
            widget.onChanged(newQuantity);
          }
        },
      ),
    );
  }
}