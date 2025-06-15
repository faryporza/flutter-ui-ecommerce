import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/product_card.dart';
import '../../../theme/text_styles.dart';
import '../../../theme/colors.dart';
import '../../../state/mock_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildSearchContent(searchQuery, searchResultsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _performSearch('');
                },
              )
            : null,
      ),
      onChanged: (value) {
        _performSearch(value);
      },
    );
  }

  Widget _buildSearchContent(String searchQuery, AsyncValue searchResultsAsync) {
    if (searchQuery.isEmpty) {
      return _buildSearchSuggestions();
    }

    return searchResultsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return _buildNoResults();
        }
        return _buildSearchResults(products);
      },
      loading: () => const Expanded(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Expanded(
        child: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = ['iPhone', 'Samsung', 'Nike', 'MacBook'];
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 12),
          ...suggestions.map((suggestion) => ListTile(
            leading: const Icon(Icons.trending_up, color: AppColors.grey500),
            title: Text(suggestion),
            onTap: () {
              _searchController.text = suggestion;
              _performSearch(suggestion);
            },
          )),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(products) {
    return Expanded(
      child: GridView.builder(
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
    );
  }
}
