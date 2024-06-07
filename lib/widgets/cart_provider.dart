import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  DatabaseReference _cartRef =
      FirebaseDatabase.instance.reference().child('carts');

  List<Map<String, dynamic>> get items => _items;

  CartProvider() {
    _fetchCartFromFirebase();
  }

  void _fetchCartFromFirebase() {
    _cartRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        _items.clear();
        data.forEach((key, value) {
          _items.add(value);
        });
        notifyListeners();
      }
    }, onError: (error) {
      print('Error fetching cart from Firebase: $error');
    });
  }

  void _saveCartToFirebase() {
    _cartRef.set(_items).then((_) {
      print('Cart successfully saved to Firebase');
    }).catchError((error) {
      print('Error saving cart to Firebase: $error');
    });
  }

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
}
