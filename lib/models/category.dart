import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  const Category({
    required this.name,
    required this.icon,
  });
}

class Categories {
  static const List<Category> all = [
    Category(
      name: 'Újdonságok',
      icon: Icons.new_releases,
    ),
    Category(
      name: 'Akciók',
      icon: Icons.local_offer,
    ),
    Category(
      name: 'Elektronika',
      icon: Icons.devices,
    ),
    Category(
      name: 'Ruházat',
      icon: Icons.checkroom,
    ),
    Category(
      name: 'Otthon',
      icon: Icons.home,
    ),
    Category(
      name: 'Sport',
      icon: Icons.sports_basketball,
    ),
  ];

  static Category? getByName(String name) {
    try {
      return all.firstWhere((category) => category.name == name);
    } catch (e) {
      return null;
    }
  }
} 