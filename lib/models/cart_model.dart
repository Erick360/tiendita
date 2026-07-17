class CartModel{
  final int productId;
  final String name;
  final double newPrice;
  int quantity;
  int stock;
  CartModel({required this.productId,required this.name, required this.newPrice, this.quantity = 1, required this.stock});

  double get total => newPrice * quantity;
  CartModel copyWith({
    int? productId,
    String? name,
    double? newPrice,
    int? quantity,
    int? stock,
  }) {
    return CartModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      newPrice: newPrice ?? this.newPrice,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
    );
  }
}