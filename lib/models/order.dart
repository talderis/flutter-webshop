class Order {
  final String id;
  final DateTime date;
  final double total;
  final String status;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
} 