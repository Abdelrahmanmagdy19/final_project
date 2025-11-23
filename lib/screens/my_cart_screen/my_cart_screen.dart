import 'package:cure_link/models/cart_item_model.dart';
import 'package:cure_link/services/cart_service.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  final CartService cartService = CartService();

  void _updateQuantity(CartItemModel item, int newQuantity) {
    if (newQuantity <= 0) {
      cartService.removeItem(item.medicine.id);
    } else {
      setState(() {
        item.quantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartService.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartService.cartItems[index];
                return _buildCartItem(item);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Detail',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildDetailRow('Subtotal', cartService.subtotal),
                _buildDetailRow('Taxes', cartService.taxes),
                _buildDetailRow('Total', cartService.total, isTotal: true),

                const SizedBox(height: 20),

                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColor.darkGreyColor2.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'VISA',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Change',
                        style: TextStyle(color: AppColor.darkGreyColor2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 20,
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total\n\$ ${cartService.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomButton(
                  text: 'Buy Now',
                  buttonWidth: 200,
                  buttonHeight: 50,
                  onTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: AppColor.greenColor,
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Payment Successful!'),
                          ],
                        ),
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pushAndRemoveUntil(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomNavigationBar(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? Colors.black : AppColor.darkGreyColor2,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$ ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.network(item.medicine.imagePathNote, width: 50, height: 50),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.medicine.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    item.medicine.quantityPcs,
                    style: TextStyle(color: AppColor.darkGreyColor2),
                  ), // افتراضي
                ],
              ),
            ),

            // Quantity controls
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.darkGreyColor2.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _buildQuantityButton(
                    Icons.remove,
                    () => _updateQuantity(item, item.quantity - 1),
                  ),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildQuantityButton(
                    Icons.add,
                    () => _updateQuantity(item, item.quantity + 1),
                    isAdd: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      cartService.removeItem(item.medicine.id);
                    });
                  },
                ),
                Text(
                  '\$ ${item.totalItemPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback onPressed, {
    bool isAdd = false,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isAdd ? AppColor.greenColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: isAdd ? Colors.white : Colors.black),
        onPressed: () {
          setState(() {
            onPressed();
          });
        },
      ),
    );
  }
}
