import 'package:cure_link/models/medicine_model.dart';

class CartItemModel {
  final MedicineModel medicine;
  int quantity;

  CartItemModel({required this.medicine, required this.quantity});

  double get totalItemPrice {
    final priceString = medicine.priceNote.replaceAll(RegExp(r'[^\d.]'), '');
    final price = double.tryParse(priceString) ?? 0.0;
    return price * quantity;
  }
}
