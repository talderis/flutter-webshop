import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesService extends ChangeNotifier {
  final Set<String> _favoriteIds = {};
  final Map<String, Product> _products = {};

  List<Product> get favorites => _favoriteIds
      .map((id) => _products[id])
      .whereType<Product>()
      .toList();

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
      _products.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
      _products[product.id] = product;
    }
    notifyListeners();
  }

  void addToFavorites(Product product) {
    _favoriteIds.add(product.id);
    _products[product.id] = product;
    notifyListeners();
  }

  void removeFromFavorites(String productId) {
    _favoriteIds.remove(productId);
    _products.remove(productId);
    notifyListeners();
  }

  void clear() {
    _favoriteIds.clear();
    _products.clear();
    notifyListeners();
  }
} 