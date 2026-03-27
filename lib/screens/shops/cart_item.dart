import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem{
  final int productId;
  final String name;
  final double price;
  int quantity;
  int stock;
  CartItem({required this.productId,required this.name, required this.price, this.quantity = 1, required this.stock});

  double get total => price * quantity;
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final index = state.indexWhere((element) => element.productId == item.productId);
    if (index != -1) {

      final newState = [...state];
      newState[index].quantity++;
      state = newState;
    } else {

      state = [...state, item];
    }
  }

  void updateQuantity(int id, int newQuantity) {
    if (newQuantity <= 0) {
      state = state.where((item) => item.productId != id).toList();
      return;
    }
    final newState = [...state];
    final index = newState.indexWhere((item) => item.productId == id);
    if (index != -1) {
      newState[index].quantity = newQuantity;
      state = newState;
    }
  }

  void clearCart() => state = [];


  double get subtotal => state.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.16;
  double get total => subtotal + tax;
}


final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});