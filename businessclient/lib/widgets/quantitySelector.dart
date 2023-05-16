import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantitySelector extends StatefulWidget {
  int quantity;
  final ValueChanged<int> onChanged;

  QuantitySelector({required this.quantity, required this.onChanged});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  void _increaseQuantity() {
    widget.onChanged(widget.quantity + 1);
  }

  void _decreaseQuantity() {
    if (widget.quantity > 1) {
      widget.onChanged(widget.quantity - 1);
    }
  }

  void _onQuantityChanged(String value) {
    final parsedValue = int.tryParse(value);
    if (parsedValue != null) {
      widget.onChanged(parsedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          color: Colors.grey,
          onPressed: _decreaseQuantity,
        ),
        Text(
          widget.quantity.toString(),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_drop_up_outlined),
          color: Colors.grey,
          onPressed: _increaseQuantity,
        ),
      ],
    );
  }
}
