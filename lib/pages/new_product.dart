import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;
  final String _userId = '9cCUEvHyVfhFxAz5ianLFjFqr552';

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(_userId)
              .collection('items')
              .doc(productId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final productData = snapshot.data!;
            final title = productData['title'].toString();
            final price = productData['price'].toString();

            _titleController.text = title;
            _priceController.text = price;

            return Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận sửa sản phẩm'),
                            content: const Text(
                                'Bạn có chắc muốn lưu các thay đổi không?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Hủy'),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(_userId)
                                      .collection('items')
                                      .doc(productId)
                                      .update({
                                    'title': _titleController.text,
                                    'price': _priceController.text,
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Lưu',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Lưu'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận xóa sản phẩm'),
                            content: const Text(
                                'Bạn có chắc muốn xóa sản phẩm này không?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Hủy'),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(_userId)
                                      .collection('items')
                                      .doc(productId)
                                      .delete();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Xóa',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Xóa',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
