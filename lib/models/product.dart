
class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> images;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isOnSale;
  final double? salePrice;
  final int stockQuantity;
  final List<String> tags;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOnSale = false,
    this.salePrice,
    required this.stockQuantity,
    required this.tags,
    required this.createdAt,
  });
} 