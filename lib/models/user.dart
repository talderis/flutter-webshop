import 'order.dart';

class User {
  final String id;
  final String name;
  final String email;
  final double balance;
  final String address;
  final String phoneNumber;
  final String? profileImage;
  final List<String> favoriteProducts;
  final List<Order> orderHistory;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.address,
    required this.phoneNumber,
    this.profileImage,
    required this.favoriteProducts,
    required this.orderHistory,
  });
} 