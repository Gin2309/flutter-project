import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(Map<String, dynamic> product) {
    final index = _items.indexWhere((item) => item['id'] == product['id']);
    if (index >= 0) {
      _items[index]['quantity'] += 1;
    } else {
      _items.add({...product, 'quantity': 1});
    }
    _saveCartToFirebase();
    notifyListeners();
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item['id'] == id);
    _saveCartToFirebase();
    notifyListeners();
  }

  void increaseQuantity(int id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      _items[index]['quantity'] += 1;
      _saveCartToFirebase();
      notifyListeners();
    }
  }

  void decreaseQuantity(int id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0 && _items[index]['quantity'] > 1) {
      _items[index]['quantity'] -= 1;
      _saveCartToFirebase();
      notifyListeners();
    }
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  Future<void> _saveCartToFirebase() async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('carts').doc('user_cart').set({
      'items': _items,
      'totalAmount': totalAmount,
    });
  }
}
