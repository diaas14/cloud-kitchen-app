import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String providerId;
  final String name;
  final double price;
  final String? imageUrl;
  int units;

  CartItem({
    required this.id,
    required this.providerId,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.units,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'units': units,
    };
  }

  int getUnits() {
    return units;
  }
}

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get cartItemCount => _items.length;

  double get totalCartPrice {
    double total = 0;
    _items.forEach((key, item) {
      total += item.price * item.units;
    });
    return total;
  }

  void addItem(CartItem item) {
    if (_items.isNotEmpty &&
        _items.values.any(
            (existingItem) => existingItem.providerId != item.providerId)) {
      throw Exception("Cannot add items from different food providers.");
    }
    if (_items.containsKey(item.id)) {
      _items[item.id]!.units += item.units;
    } else {
      _items[item.id] = item;
    }
    notifyListeners();
  }

  void removeItemFromCart(String itemId) {
    if (_items.containsKey(itemId)) {
      final item = _items[itemId]!;
      item.units--;

      if (item.units == 0) {
        _items.remove(itemId);
      }

      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
