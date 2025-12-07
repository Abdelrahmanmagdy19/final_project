import 'package:cure_link/models/cart_item_model.dart';
import 'package:cure_link/models/medicine_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;

  void addToCart(MedicineModel medicine, int quantity) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItemModel(medicine: medicine, quantity: quantity));
    }
  }

  void removeItem(int medicineId) {
    _cartItems.removeWhere((item) => item.medicine.id == medicineId);
  }

  double get subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalItemPrice);
  }

  double get taxes => 1.00;

  double get total => subtotal + taxes;
}
