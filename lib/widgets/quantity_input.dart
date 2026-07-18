import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiendita/models/quantity_model.dart';

class QuantityInput extends StatefulWidget {
  final QuantityModel model;
  const QuantityInput({super.key, required this.model});


  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.model.initialQuantity.toString());
  }

  @override
  void didUpdateWidget(QuantityInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model.initialQuantity != oldWidget.model.initialQuantity &&
        int.tryParse(_controller.text) != widget.model.initialQuantity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.model.initialQuantity.toString();
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
        maxLength: 3,
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
          counterText: '',
        ),
        onChanged: (value) {
          final newQuantity = int.tryParse(value);
          if (newQuantity != null && newQuantity >=0) {
            if(newQuantity > widget.model.maxStock){
              widget.model.onChanged(widget.model.maxStock);
              _controller.text = widget.model.maxStock.toString();
            }else{
              widget.model.onChanged(newQuantity);
            }
          } else if(value.isEmpty){
            widget.model.onChanged(1);
          }
        },
      ),
    );
  }
}