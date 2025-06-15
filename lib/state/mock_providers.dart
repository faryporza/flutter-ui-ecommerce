import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/product.dart';
import '../model/user.dart';
import '../services/mock_data_service.dart';

// Products providers
final productsProvider = FutureProvider<List<Product>>((ref) async {
  return MockDataService.loadProducts();
});

final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  return MockDataService.getFeaturedProducts();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return MockDataService.loadCategories();
});

// Search provider
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return MockDataService.searchProducts(query);
});

// Category filter provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  if (selectedCategory == null) {
    return MockDataService.loadProducts();
  }
  return MockDataService.getProductsByCategory(selectedCategory);
});

// User providers
final usersProvider = FutureProvider<List<User>>((ref) async {
  return MockDataService.loadUsers();
});

final currentUserProvider = StateProvider<User?>((ref) => null);

// Favorites provider (using StateNotifier for mutable state)
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]);

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }

  void clearFavorites() {
    state = [];
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

// Cart provider
class CartItem {
  final String productId;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.quantity,
  });

  CartItem copyWith({
    String? productId,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(String productId, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.productId == productId);
    
    if (existingIndex >= 0) {
      // Update existing item
      final updatedItems = [...state];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      state = updatedItems;
    } else {
      // Add new item
      state = [...state, CartItem(productId: productId, quantity: quantity)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final updatedItems = state.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = updatedItems;
  }

  void clearCart() {
    state = [];
  }

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);

  bool isInCart(String productId) {
    return state.any((item) => item.productId == productId);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Cart total provider
final cartTotalProvider = FutureProvider<double>((ref) async {
  final cartItems = ref.watch(cartProvider);
  final products = await ref.watch(productsProvider.future);
  
  double total = 0.0;
  for (final item in cartItems) {
    final product = products.where((p) => p.id == item.productId).firstOrNull;
    if (product != null) {
      total += product.discountedPrice * item.quantity;
    }
  }
  
  return total;
});
