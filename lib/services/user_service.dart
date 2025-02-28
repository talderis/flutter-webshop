import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import '../models/order.dart';

class UserService extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    try {
      // Firebase helyett egyszerű mock bejelentkezés
      if (email == 'test@example.com' && password == 'password') {
        _currentUser = User(
          id: 'test-user-id',
          name: 'Teszt Felhasználó',
          email: email,
          balance: 50000,
          address: '1234 Budapest, Teszt utca 1.',
          phoneNumber: '+36 30 123 4567',
          profileImage: null,
          favoriteProducts: [],
          orderHistory: [
            Order(
              id: '1',
              date: DateTime.now().subtract(const Duration(days: 7)),
              total: 15000,
              status: 'Teljesítve',
              items: [
                const OrderItem(
                  productId: '1',
                  productName: 'Teszt termék 1',
                  price: 10000,
                  quantity: 1,
                ),
                const OrderItem(
                  productId: '2',
                  productName: 'Teszt termék 2',
                  price: 5000,
                  quantity: 1,
                ),
              ],
            ),
            Order(
              id: '2',
              date: DateTime.now().subtract(const Duration(days: 14)),
              total: 25000,
              status: 'Teljesítve',
              items: [
                const OrderItem(
                  productId: '3',
                  productName: 'Teszt termék 3',
                  price: 25000,
                  quantity: 1,
                ),
              ],
            ),
          ],
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Hiba történt a bejelentkezés során: $e');
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      // Mock regisztráció
      _currentUser = User(
        id: 'new-user-id',
        name: name,
        email: email,
        balance: 0,
        address: '',
        phoneNumber: '',
        profileImage: null,
        favoriteProducts: [],
        orderHistory: [],
      );
      notifyListeners();
    } catch (e) {
      throw Exception('Hiba történt a regisztráció során: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // Mock jelszó visszaállítás
      // Valós implementációban itt küldenénk e-mailt
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Hiba történt a jelszó visszaállítás során: $e');
    }
  }

  Future<void> logout() async {
    // Mock kijelentkezés
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? address,
    String? phoneNumber,
    String? profileImage,
  }) async {
    if (_currentUser == null) return;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = User(
      id: _currentUser!.id,
      name: name ?? _currentUser!.name,
      email: _currentUser!.email,
      balance: _currentUser!.balance,
      address: address ?? _currentUser!.address,
      phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
      profileImage: profileImage ?? _currentUser!.profileImage,
      favoriteProducts: _currentUser!.favoriteProducts,
      orderHistory: _currentUser!.orderHistory,
    );

    notifyListeners();
  }

  Future<void> addToBalance(double amount) async {
    if (_currentUser == null) return;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = User(
      id: _currentUser!.id,
      name: _currentUser!.name,
      email: _currentUser!.email,
      balance: _currentUser!.balance + amount,
      address: _currentUser!.address,
      phoneNumber: _currentUser!.phoneNumber,
      profileImage: _currentUser!.profileImage,
      favoriteProducts: _currentUser!.favoriteProducts,
      orderHistory: _currentUser!.orderHistory,
    );

    notifyListeners();
  }

  Future<void> deductFromBalance(double amount) async {
    if (_currentUser == null) return;
    if (_currentUser!.balance < amount) {
      throw Exception('Nincs elég egyenleg a vásárláshoz');
    }

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = User(
      id: _currentUser!.id,
      name: _currentUser!.name,
      email: _currentUser!.email,
      balance: _currentUser!.balance - amount,
      address: _currentUser!.address,
      phoneNumber: _currentUser!.phoneNumber,
      profileImage: _currentUser!.profileImage,
      favoriteProducts: _currentUser!.favoriteProducts,
      orderHistory: _currentUser!.orderHistory,
    );

    notifyListeners();
  }

  Future<void> addToOrderHistory(Order order) async {
    if (_currentUser == null) return;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedOrderHistory = List<Order>.from(_currentUser!.orderHistory)
      ..add(order);

    _currentUser = User(
      id: _currentUser!.id,
      name: _currentUser!.name,
      email: _currentUser!.email,
      balance: _currentUser!.balance,
      address: _currentUser!.address,
      phoneNumber: _currentUser!.phoneNumber,
      profileImage: _currentUser!.profileImage,
      favoriteProducts: _currentUser!.favoriteProducts,
      orderHistory: updatedOrderHistory,
    );

    notifyListeners();
  }

  Future<void> addToFavorites(String productId) async {
    if (_currentUser == null) return;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedFavorites = List<String>.from(_currentUser!.favoriteProducts)
      ..add(productId);

    _currentUser = User(
      id: _currentUser!.id,
      name: _currentUser!.name,
      email: _currentUser!.email,
      balance: _currentUser!.balance,
      address: _currentUser!.address,
      phoneNumber: _currentUser!.phoneNumber,
      profileImage: _currentUser!.profileImage,
      favoriteProducts: updatedFavorites,
      orderHistory: _currentUser!.orderHistory,
    );

    notifyListeners();
  }

  Future<void> removeFromFavorites(String productId) async {
    if (_currentUser == null) return;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedFavorites = List<String>.from(_currentUser!.favoriteProducts)
      ..remove(productId);

    _currentUser = User(
      id: _currentUser!.id,
      name: _currentUser!.name,
      email: _currentUser!.email,
      balance: _currentUser!.balance,
      address: _currentUser!.address,
      phoneNumber: _currentUser!.phoneNumber,
      profileImage: _currentUser!.profileImage,
      favoriteProducts: updatedFavorites,
      orderHistory: _currentUser!.orderHistory,
    );

    notifyListeners();
  }
} 