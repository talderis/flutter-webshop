import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductService extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Gaming Laptop',
      price: 299990,
      description: '''
Erős gaming laptop a legújabb játékokhoz.
- Intel Core i7 processzor
- NVIDIA RTX 3060 grafikus kártya
- 16GB RAM
- 512GB SSD
- 15.6" 144Hz kijelző
''',
      images: [
        'prod/laptop.png',
      ],
      category: 'Elektronika',
      rating: 4.5,
      reviewCount: 128,
      isOnSale: true,
      salePrice: 279990,
      stockQuantity: 5,
      tags: ['laptop', 'gaming', 'nvidia', 'intel'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '2',
      name: 'Vezeték nélküli fejhallgató',
      price: 29990,
      description: '''
Kiváló minőségű vezeték nélküli fejhallgató.
- Aktív zajszűrés
- 30 órás akkumulátor
- Bluetooth 5.0
- Beépített mikrofon
- Érintésvezérlés
''',
      images: [
        'prod/fulhal.png',
      ],
      category: 'Elektronika',
      rating: 4.8,
      reviewCount: 256,
      isOnSale: false,
      stockQuantity: 15,
      tags: ['audio', 'fejhallgató', 'bluetooth'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '3',
      name: 'Okosóra',
      price: 49990,
      description: '''
Modern okosóra fitness funkciókkal.
- Pulzusmérés
- Véroxigénszint mérés
- GPS
- 5 ATM vízállóság
- 14 napos akkumulátor
''',
      images: [
        'prod/ora.png',
      ],
      category: 'Elektronika',
      rating: 4.6,
      reviewCount: 89,
      isOnSale: true,
      salePrice: 44990,
      stockQuantity: 8,
      tags: ['okosóra', 'fitness', 'sport'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '4',
      name: 'Futócipő',
      price: 24990,
      description: '''
Professzionális futócipő minden felületre.
- Légpárnás talp
- Breathable mesh felső
- Stabil sarokrész
- Reflektív elemek
''',
      images: [
        'prod/cipo.png',
      ],
      category: 'Sport',
      rating: 4.7,
      reviewCount: 156,
      isOnSale: false,
      stockQuantity: 20,
      tags: ['cipő', 'futás', 'sport'],
      createdAt: DateTime.now(),
    ),
  ];

  List<Product> get products => List.unmodifiable(_products);

  List<Product> getProductsByCategory(String category) {
    if (category == 'Összes') {
      return products;
    }
    return _products.where((p) => p.category == category).toList();
  }

  List<Product> get onSaleProducts =>
      _products.where((p) => p.isOnSale).toList();

  List<Product> searchProducts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _products.where((p) {
      return p.name.toLowerCase().contains(lowercaseQuery) ||
          p.description.toLowerCase().contains(lowercaseQuery) ||
          p.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
} 