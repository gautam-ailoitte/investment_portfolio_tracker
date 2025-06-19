// lib/src/presentation/widgets/stock_card.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_theme.dart';
import '../../core/utils/responsive_helper.dart';

class StockCard extends StatelessWidget {
  final String symbol;
  final String? companyName;
  final String currentPrice;
  final String? change;
  final String? changePercentage;
  final String? logoUrl;
  final IconData? icon;
  final Color? changeColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool showDivider;
  final Widget? trailing;

  const StockCard({
    super.key,
    required this.symbol,
    this.companyName,
    required this.currentPrice,
    this.change,
    this.changePercentage,
    this.logoUrl,
    this.icon,
    this.changeColor,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.showDivider = false,
    this.trailing,
  });

  /// Factory for portfolio card
  factory StockCard.portfolio({
    required String name,
    required String description,
    required String value,
    String? change,
    String? changePercentage,
    VoidCallback? onTap,
  }) {
    return StockCard(
      symbol: name,
      companyName: description,
      currentPrice: value,
      change: change,
      changePercentage: changePercentage,
      icon: Icons.folder_outlined,
      onTap: onTap,
    );
  }

  /// Factory for watchlist stock
  factory StockCard.watchlist({
    required String symbol,
    required String companyName,
    required String currentPrice,
    String? change,
    String? changePercentage,
    String? logoUrl,
    VoidCallback? onTap,
    VoidCallback? onRemove,
  }) {
    return StockCard(
      symbol: symbol,
      companyName: companyName,
      currentPrice: currentPrice,
      change: change,
      changePercentage: changePercentage,
      logoUrl: logoUrl,
      onTap: onTap,
      trailing: onRemove != null
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onRemove,
              color: AppColors.error,
            )
          : null,
    );
  }

  Color get _changeColor {
    if (changeColor != null) return changeColor!;
    if (change == null) return AppColors.textSecondary;
    if (change!.startsWith('+')) return AppColors.profit;
    if (change!.startsWith('-')) return AppColors.loss;
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final cardPadding = padding ?? const EdgeInsets.all(AppDimensions.paddingM);
    final cardMargin =
        margin ?? const EdgeInsets.symmetric(vertical: AppDimensions.spaceXS);

    return Container(
      margin: cardMargin,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.border.withOpacity(0.2),
          width: 0.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Column(
            children: [
              Padding(padding: cardPadding, child: _buildCardContent(context)),
              if (showDivider)
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColors.border,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Row(
      children: [
        // Logo/Icon
        _buildLeadingWidget(context),

        const SizedBox(width: AppDimensions.spaceM),

        // Stock info (symbol & company name)
        Expanded(child: _buildStockInfo(context)),

        const SizedBox(width: AppDimensions.spaceM),

        // Price info or trailing widget
        trailing ?? _buildPriceInfo(context),
      ],
    );
  }

  Widget _buildLeadingWidget(BuildContext context) {
    final iconSize = ResponsiveHelper.getResponsiveIconSize(
      context,
      baseSize: 40,
    );

    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          color: AppColors.surface,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          child: Image.network(
            logoUrl!,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultIcon(context, iconSize);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return _buildDefaultIcon(context, iconSize);
  }

  Widget _buildDefaultIcon(BuildContext context, double iconSize) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Icon(
        icon ?? Icons.business,
        size: iconSize * 0.6,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildStockInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Symbol
        Text(
          symbol.toUpperCase(),
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        // Company name
        if (companyName != null && companyName!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            companyName!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ],
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current price
        Text(
          currentPrice,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        // Change information
        if (change != null || changePercentage != null) ...[
          const SizedBox(height: 2),
          _buildChangeInfo(context),
        ],
      ],
    );
  }

  Widget _buildChangeInfo(BuildContext context) {
    if (change != null && changePercentage != null) {
      // Show both change amount and percentage
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            change!,
            style: AppTextStyles.bodySmall.copyWith(
              color: _changeColor,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            changePercentage!,
            style: AppTextStyles.bodySmall.copyWith(
              color: _changeColor,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else if (change != null) {
      // Show only change amount
      return Text(
        change!,
        style: AppTextStyles.bodySmall.copyWith(
          color: _changeColor,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      );
    } else if (changePercentage != null) {
      // Show only percentage
      return Text(
        changePercentage!,
        style: AppTextStyles.bodySmall.copyWith(
          color: _changeColor,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }

    return const SizedBox.shrink();
  }
}

/// Compact stock card for lists with many items
class CompactStockCard extends StatelessWidget {
  final String symbol;
  final String currentPrice;
  final String? change;
  final Color? changeColor;
  final VoidCallback? onTap;

  const CompactStockCard({
    super.key,
    required this.symbol,
    required this.currentPrice,
    this.change,
    this.changeColor,
    this.onTap,
  });

  Color get _changeColor {
    if (changeColor != null) return changeColor!;
    if (change == null) return AppColors.textSecondary;
    if (change!.startsWith('+')) return AppColors.profit;
    if (change!.startsWith('-')) return AppColors.loss;
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        child: Row(
          children: [
            // Symbol
            Expanded(
              flex: 2,
              child: Text(
                symbol.toUpperCase(),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Price
            Expanded(
              flex: 2,
              child: Text(
                currentPrice,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Change
            if (change != null)
              Expanded(
                flex: 2,
                child: Text(
                  change!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _changeColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Stock card specifically for search results
class SearchStockCard extends StatelessWidget {
  final String symbol;
  final String companyName;
  final String? sector;
  final String? logoUrl;
  final VoidCallback? onTap;
  final bool isInWatchlist;
  final VoidCallback? onWatchlistToggle;

  const SearchStockCard({
    super.key,
    required this.symbol,
    required this.companyName,
    this.sector,
    this.logoUrl,
    this.onTap,
    this.isInWatchlist = false,
    this.onWatchlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          children: [
            // Logo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: logoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusS,
                      ),
                      child: Image.network(
                        logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.business,
                            color: AppColors.textSecondary,
                          );
                        },
                      ),
                    )
                  : const Icon(Icons.business, color: AppColors.textSecondary),
            ),

            const SizedBox(width: AppDimensions.spaceM),

            // Stock info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol.toUpperCase(),
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    companyName,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (sector != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      sector!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Watchlist button
            if (onWatchlistToggle != null)
              IconButton(
                icon: Icon(
                  isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                  color: isInWatchlist
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                onPressed: onWatchlistToggle,
              ),
          ],
        ),
      ),
    );
  }
}
