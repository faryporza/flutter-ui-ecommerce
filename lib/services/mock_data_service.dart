import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/product.dart';
import '../model/user.dart';

class MockDataService {
  static const String _productsPath = 'assets/data/products.json';
  static const String _usersPath = 'assets/data/users.json';
  static const String _categoriesPath = 'assets/data/categories.json';

  // Load products from JSON
  static Future<List<Product>> loadProducts() async {
    try {
      final String jsonString = await rootBundle.loadString(_productsPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> productsJson = jsonData['products'];
      
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Load users from JSON
  static Future<List<User>> loadUsers() async {
    try {
      final String jsonString = await rootBundle.loadString(_usersPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> usersJson = jsonData['users'];
      
      return usersJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // Load categories from JSON
  static Future<List<Category>> loadCategories() async {
    try {
      final String jsonString = await rootBundle.loadString(_categoriesPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> categoriesJson = jsonData['categories'];
      
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // Get product by ID
  static Future<Product?> getProductById(String id) async {
    final products = await loadProducts();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get products by category
  static Future<List<Product>> getProductsByCategory(String category) async {
    final products = await loadProducts();
    return products.where((product) => 
      product.category.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  // Search products
  static Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];
    
    final products = await loadProducts();
    final lowercaseQuery = query.toLowerCase();
    
    return products.where((product) => 
      product.name.toLowerCase().contains(lowercaseQuery) ||
      product.description.toLowerCase().contains(lowercaseQuery) ||
      product.category.toLowerCase().contains(lowercaseQuery) ||
      product.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  // Get featured products (with discounts or high ratings)
  static Future<List<Product>> getFeaturedProducts() async {
    final products = await loadProducts();
    return products.where((product) => 
      product.hasDiscount || product.rating >= 4.5
    ).take(6).toList();
  }

  // Simulate network delay
  static Future<T> _simulateNetworkDelay<T>(T data, {int milliseconds = 500}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    return data;
  }

  // Get products with simulated delay
  static Future<List<Product>> loadProductsWithDelay() async {
    final products = await loadProducts();
    return _simulateNetworkDelay(products);
  }
}

// Category model for the categories JSON
class Category {
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final int productCount;
  final bool isActive;
  final int sortOrder;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.productCount,
    this.isActive = true,
    this.sortOrder = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String?,
      productCount: json['productCount'] as int,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'productCount': productCount,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}
