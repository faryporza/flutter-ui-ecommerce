import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/product_card.dart';
import '../../../theme/text_styles.dart';
import '../../../theme/colors.dart';
import '../../../state/mock_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredProductsAsync = ref.watch(featuredProductsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildCategoriesSection(categoriesAsync),
            const SizedBox(height: 24),
            _buildFeaturedProductsSection(featuredProductsAsync, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover amazing products',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.shopping_bag_outlined,
            color: AppColors.white,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(AsyncValue categoriesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: categoriesAsync.when(
            data: (categories) => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: index == 0 ? AppColors.primary : AppColors.grey100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category.name,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: index == 0 ? AppColors.white : AppColors.grey700,
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProductsSection(AsyncValue featuredProductsAsync, WidgetRef ref) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: AppTextStyles.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: featuredProductsAsync.when(
              data: (products) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final favorites = ref.watch(favoritesProvider);
                  
                  return ProductCard(
                    title: product.name,
                    price: product.price,
                    description: product.description,
                    imageUrl: product.imageUrl,
                    rating: product.rating,
                    discountPercentage: product.discountPercentage,
                    isFavorite: favorites.contains(product.id),
                    onTap: () {
                      // Navigate to product detail
                    },
                    onFavoritePressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(product.id);
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading products: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
