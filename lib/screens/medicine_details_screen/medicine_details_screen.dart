import 'package:cure_link/models/medicine_model.dart';
import 'package:cure_link/screens/my_cart_screen/my_cart_screen.dart';
import 'package:cure_link/services/cart_service.dart'; // import the new service
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:flutter/material.dart';

class MedicineDetailsScreen extends StatefulWidget {
  const MedicineDetailsScreen({super.key, required this.medicineModel});
  final MedicineModel medicineModel;

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  int quantity = 1;
  final CartService _cartService = CartService();

  void _addToCartAndNavigate() {
    _cartService.addToCart(widget.medicineModel, quantity);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyCartScreen()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColor.greenColor,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('${widget.medicineModel.name} x$quantity added to cart!'),
          ],
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  widget.medicineModel.imagePathNote,
                  width: 163,
                  height: 163,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.medicineModel.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.medicineModel.quantityPcs,
                style: TextStyle(fontSize: 16, color: AppColor.darkGreyColor2),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$quantity'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.medicineModel.priceNote,
                    style: const TextStyle(
                      fontSize: 26,
                      color: AppColor.greenColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Text(
                'Main Use',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 1),
              Text(
                widget.medicineModel.mainUse,
                style: TextStyle(fontSize: 14, color: AppColor.darkGreyColor2),
              ),
              const SizedBox(height: 10),
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 1),
              Text(
                widget.medicineModel.description,
                style: TextStyle(fontSize: 14, color: AppColor.darkGreyColor2),
              ),
              const SizedBox(height: 10),

              CustomButton(
                text: 'Add to Cart',
                buttonWidth: double.infinity,
                buttonHeight: 50,
                onTap: _addToCartAndNavigate,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
