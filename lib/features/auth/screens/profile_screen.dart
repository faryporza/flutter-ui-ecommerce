import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../theme/text_styles.dart';
import '../../../theme/colors.dart';
import '../../../state/mock_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final favoritesCount = ref.watch(favoritesProvider).length;
    final cartItemsCount = ref.watch(cartProvider).fold<int>(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: null,
          ),
        ],
      ),
      body: usersAsync.when(
        data: (users) {
          // Use the first user as the current user
          final currentUser = users.isNotEmpty ? users.first : null;
          
          if (currentUser == null) {
            return const Center(child: Text('No user data found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(currentUser),
                const SizedBox(height: 24),
                _buildProfileStats(favoritesCount, cartItemsCount),
                const SizedBox(height: 24),
                _buildProfileOptions(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading profile: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(usersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.grey200,
                backgroundImage: user.profileImageUrl != null 
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl == null
                    ? Text(
                        user.initials,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.grey600,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
          ),
          if (user.phoneNumber != null) ...[
            const SizedBox(height: 4),
            Text(
              user.phoneNumber!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user.isEmailVerified) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Email Verified',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (user.isPhoneVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone_android,
                        size: 14,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Phone Verified',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (user.address != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${user.address}, ${user.city ?? ''}, ${user.country ?? ''}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileStats(int favoritesCount, int cartItemsCount) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Orders', '12')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Favorites', '$favoritesCount')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Cart Items', '$cartItemsCount')),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    final options = [
      {'icon': Icons.shopping_bag_outlined, 'title': 'My Orders', 'subtitle': 'Track your orders'},
      {'icon': Icons.favorite_outline, 'title': 'Favorites', 'subtitle': 'Your wishlist'},
      {'icon': Icons.location_on_outlined, 'title': 'Addresses', 'subtitle': 'Manage delivery addresses'},
      {'icon': Icons.payment_outlined, 'title': 'Payment Methods', 'subtitle': 'Saved cards & wallets'},
      {'icon': Icons.notifications_outlined, 'title': 'Notifications', 'subtitle': 'Alerts & updates'},
      {'icon': Icons.help_outline, 'title': 'Help & Support', 'subtitle': 'FAQs & contact us'},
      {'icon': Icons.logout, 'title': 'Logout', 'subtitle': 'Sign out of your account', 'isDestructive': true},
    ];

    return Column(
      children: options.map((option) {
        final isDestructive = option['isDestructive'] as bool? ?? false;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(
              option['icon'] as IconData,
              color: isDestructive ? AppColors.error : AppColors.grey600,
            ),
            title: Text(
              option['title'] as String,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDestructive ? AppColors.error : null,
              ),
            ),
            subtitle: Text(
              option['subtitle'] as String,
              style: AppTextStyles.bodySmall,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDestructive ? AppColors.error : AppColors.grey400,
            ),
            onTap: () {
              // Handle option tap
            },
          ),
        );
      }).toList(),
    );
  }
}
