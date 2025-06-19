// lib/src/presentation/widgets/bottom_navigation.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/constants/app_theme.dart';
import '../../core/utils/responsive_helper.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final List<BottomNavigationItem>? customItems;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.customItems,
  });

  static const List<BottomNavigationItem> _defaultItems = [
    BottomNavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: AppStrings.home,
    ),
    BottomNavigationItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: AppStrings.search,
    ),
    BottomNavigationItem(
      icon: Icons.article_outlined,
      activeIcon: Icons.article,
      label: AppStrings.news,
    ),
    BottomNavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: AppStrings.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = customItems ?? _defaultItems;
    final iconSize = ResponsiveHelper.getResponsiveIconSize(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: AppDimensions.bottomNavHeight,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTabChanged,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.background,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textTertiary,
            elevation: 0,
            iconSize: iconSize,
            selectedFontSize: ResponsiveHelper.isMobile(context) ? 12 : 14,
            unselectedFontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
            selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
            items: items
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: _buildIcon(
                      icon: item.icon,
                      isActive: false,
                      iconSize: iconSize,
                    ),
                    activeIcon: _buildIcon(
                      icon: item.activeIcon ?? item.icon,
                      isActive: true,
                      iconSize: iconSize,
                    ),
                    label: item.label,
                    tooltip: item.tooltip ?? item.label,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon({
    required IconData icon,
    required bool isActive,
    required double iconSize,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: isActive
          ? BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            )
          : null,
      child: Icon(
        icon,
        size: iconSize,
        color: isActive ? AppColors.primary : AppColors.textTertiary,
      ),
    );
  }
}

/// Bottom navigation item model
class BottomNavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? tooltip;
  final Widget? badge;

  const BottomNavigationItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.tooltip,
    this.badge,
  });
}

/// Custom bottom navigation with more styling options
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final List<CustomBottomNavigationItem> items;
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsets? padding;
  final bool showLabels;
  final double? height;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.items,
    this.backgroundColor,
    this.elevation,
    this.padding,
    this.showLabels = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final navHeight = height ?? AppDimensions.bottomNavHeight;

    return Container(
      height: navHeight + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  offset: const Offset(0, -2),
                  blurRadius: elevation!,
                ),
              ]
            : null,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = index == currentIndex;

              return Expanded(
                child: _buildCustomItem(
                  context: context,
                  item: item,
                  isActive: isActive,
                  onTap: () => onTabChanged(index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomItem({
    required BuildContext context,
    required CustomBottomNavigationItem item,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final iconSize = ResponsiveHelper.getResponsiveIconSize(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingXS),
                  decoration: isActive && item.showBackground
                      ? BoxDecoration(
                          color: (item.activeColor ?? AppColors.primary)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusS,
                          ),
                        )
                      : null,
                  child: Icon(
                    isActive ? (item.activeIcon ?? item.icon) : item.icon,
                    size: iconSize,
                    color: isActive
                        ? (item.activeColor ?? AppColors.primary)
                        : (item.inactiveColor ?? AppColors.textTertiary),
                  ),
                ),

                // Badge
                if (item.badge != null)
                  Positioned(right: -4, top: -4, child: item.badge!),
              ],
            ),

            // Label
            if (showLabels && item.label != null) ...[
              const SizedBox(height: AppDimensions.spaceXS),
              Text(
                item.label!,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isActive
                      ? (item.activeColor ?? AppColors.primary)
                      : (item.inactiveColor ?? AppColors.textTertiary),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom bottom navigation item model
class CustomBottomNavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Widget? badge;
  final bool showBackground;

  const CustomBottomNavigationItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.badge,
    this.showBackground = true,
  });
}

/// Simple badge widget for navigation items
class NavigationBadge extends StatelessWidget {
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showDot;

  const NavigationBadge({
    super.key,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.showDot = false,
  });

  factory NavigationBadge.dot({Color? color}) {
    return NavigationBadge(
      showDot: true,
      backgroundColor: color ?? AppColors.error,
    );
  }

  factory NavigationBadge.count({
    required String count,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return NavigationBadge(
      text: count,
      backgroundColor: backgroundColor ?? AppColors.error,
      textColor: textColor ?? Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showDot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.error,
          shape: BoxShape.circle,
        ),
      );
    }

    if (text == null || text!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      child: Text(
        text!,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor ?? Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
