import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/product_card.dart';
import '../../../theme/text_styles.dart';
import '../../../theme/colors.dart';
import '../../../state/mock_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Favorites',
        showBackButton: false,
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _showClearFavoritesDialog(context, ref);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: productsAsync.when(
          data: (allProducts) {
            final favoriteProducts = allProducts
                .where((product) => favorites.contains(product.id))
                .toList();

            if (favoriteProducts.isEmpty) {
              return _buildEmptyFavorites(context);
            }

            return _buildFavoritesList(favoriteProducts, ref);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading favorites: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFavorites(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_outline,
              size: 64,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No favorites yet',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding products to your favorites\nto see them here',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.go('/');
            },
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(favoriteProducts, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];

        return ProductCard(
          title: product.name,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          rating: product.rating,
          discountPercentage: product.discountPercentage,
          isFavorite: true,
          onTap: () {
            // Navigate to product detail
          },
          onFavoritePressed: () {
            ref.read(favoritesProvider.notifier).toggleFavorite(product.id);
          },
        );
      },
    );
  }

  void _showClearFavoritesDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Favorites'),
        content: const Text('Are you sure you want to remove all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(favoritesProvider.notifier).clearFavorites();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
