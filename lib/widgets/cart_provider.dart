import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = '9cCUEvHyVfhFxAz5ianLFjFqr552';
  final List<Map<String, dynamic>> _items = [];

  CartProvider() {
    _fetchCartFromFirestore();
  }

  List<Map<String, dynamic>> get items => _items;

  Future<void> _fetchCartFromFirestore() async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('carts').doc(_userId).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final cartItems = data['items'] as List<dynamic>;
        _items.clear();
        cartItems.forEach((item) {
          _items.add(Map<String, dynamic>.from(item));
        });
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching cart from Firestore: $error');
    }
  }

  Future<void> _saveCartToFirestore() async {
    try {
      await _firestore.collection('carts').doc(_userId).set({
        'items': _items,
      });
    } catch (error) {
      print('Error saving cart to Firestore: $error');
    }
  }

  void addItem(Map<String, dynamic> product) {
    final index = _items.indexWhere((item) => item['id'] == product['id']);
    if (index >= 0) {
      _items[index]['quantity'] += 1;
    } else {
      _items.add({...product, 'quantity': 1});
    }
    _saveCartToFirestore();
    notifyListeners();
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item['id'] == id);
    _saveCartToFirestore();
    notifyListeners();
  }

  void increaseQuantity(int id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      _items[index]['quantity'] += 1;
      _saveCartToFirestore();
      notifyListeners();
    }
  }

  void decreaseQuantity(int id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0 && _items[index]['quantity'] > 1) {
      _items[index]['quantity'] -= 1;
      _saveCartToFirestore();
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
}
