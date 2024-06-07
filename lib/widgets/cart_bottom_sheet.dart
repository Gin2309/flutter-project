import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/widgets/cart_provider.dart';

class CartBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final height = MediaQuery.of(context).size.height * 0.5;

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Giỏ hàng',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (cart.items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Không có sản phẩm trong giỏ hàng',
                style: TextStyle(fontSize: 18),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: cart.items.map((item) {
                  return ListTile(
                    title: Text(item['title']),
                    subtitle: Text('Giá: \$${item['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            cart.decreaseQuantity(item['id']);
                          },
                        ),
                        Text('${item['quantity']}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cart.increaseQuantity(item['id']);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cart.removeItem(item['id']);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          if (cart.items.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền: \$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
