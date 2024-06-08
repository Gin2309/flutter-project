import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = '9cCUEvHyVfhFxAz5ianLFjFqr552';

  Future<void> _addProduct() async {
    final String title = _titleController.text;
    final double price = double.tryParse(_priceController.text) ?? 0.0;

    if (title.isNotEmpty && price > 0) {
      try {
        await _firestore
            .collection('products')
            .doc(_userId)
            .collection('items')
            .add({
          'title': title,
          'price': price,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm sản phẩm thành công')),
        );
        _titleController.clear();
        _priceController.clear();
        _imgController.clear();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm sản phẩm thất bại: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không được bỏ trống các trường')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Giá'),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Thêm sản phẩm'),
            ),
          ],
        ),
      ),
    );
  }
}
