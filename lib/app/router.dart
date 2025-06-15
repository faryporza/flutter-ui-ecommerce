import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../features/home/screens/home_screen.dart';
import '../features/product/screens/search_screen.dart';
import '../features/product/screens/favorites_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/auth/screens/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainLayout(child: HomeScreen()),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const MainLayout(child: SearchScreen()),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const MainLayout(child: FavoritesScreen()),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const MainLayout(child: CartScreen()),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const MainLayout(child: ProfileScreen()),
      ),
    ],
  );
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key, required this.child});

  final Widget child;

  int _getCurrentIndex(String location) {
    switch (location) {
      case '/':
        return 0;
      case '/search':
        return 1;
      case '/favorites':
        return 2;
      case '/cart':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _getCurrentIndex(location),
      ),
    );
  }
}
