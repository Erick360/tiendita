import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/cart_model.dart';

class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);

  void addItem(CartModel item) {
    final index = state.indexWhere((element) => element.productId == item.productId);
    if (index != -1) {

      final newState = [...state];
      newState[index].quantity++;
      state = newState;
    } else {

      state = [...state, item];
    }
  }

  void updatePrice(int productId, double newPrice) {
    state = [
      for (final item in state)
        if (item.productId == productId)
          item.copyWith(newPrice: newPrice)
        else
          item
    ];
  }

/*
  void increaseQuantity(BuildContext context, ProductsModel products){
    final index = state.indexWhere((item) => item.productId == products.idProduct);

    if(index != -1){
      final currentCartItem = state[index];

      if(currentCartItem.quantity + 1 > products.stock){

      }
    }
  }
  */

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


final cartProvider = StateNotifierProvider<CartNotifier, List<CartModel>>((ref) {
  return CartNotifier();
});