// lib/src/presentation/widgets/portfolio_summary_card.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_theme.dart';
import '../../core/utils/responsive_helper.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? change;
  final String? changePercentage;
  final Color? valueColor;
  final Color? changeColor;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const PortfolioSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.change,
    this.changePercentage,
    this.valueColor,
    this.changeColor,
    this.icon,
    this.iconColor,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
  });

  /// Factory for total value card
  factory PortfolioSummaryCard.totalValue({
    required String value,
    String? change,
    String? changePercentage,
    VoidCallback? onTap,
  }) {
    return PortfolioSummaryCard(
      title: 'Total Value',
      value: value,
      change: change,
      changePercentage: changePercentage,
      valueColor: AppColors.textPrimary,
      changeColor: _getChangeColor(change),
      icon: Icons.account_balance_wallet_outlined,
      iconColor: AppColors.primary,
      onTap: onTap,
    );
  }

  /// Factory for today's gain/loss card
  factory PortfolioSummaryCard.todaysGain({
    required String value,
    String? changePercentage,
    VoidCallback? onTap,
  }) {
    final isPositive = value.startsWith('+');
    return PortfolioSummaryCard(
      title: "Today's Gain",
      value: value,
      changePercentage: changePercentage,
      valueColor: isPositive ? AppColors.profit : AppColors.loss,
      changeColor: isPositive ? AppColors.profit : AppColors.loss,
      icon: isPositive ? Icons.trending_up : Icons.trending_down,
      iconColor: isPositive ? AppColors.profit : AppColors.loss,
      onTap: onTap,
    );
  }

  /// Factory for cash balance card
  factory PortfolioSummaryCard.cashBalance({
    required String value,
    VoidCallback? onTap,
  }) {
    return PortfolioSummaryCard(
      title: 'Cash Balance',
      value: value,
      valueColor: AppColors.textPrimary,
      icon: Icons.payments_outlined,
      iconColor: AppColors.info,
      onTap: onTap,
    );
  }

  /// Factory for portfolio count card
  factory PortfolioSummaryCard.portfolioCount({
    required String value,
    VoidCallback? onTap,
  }) {
    return PortfolioSummaryCard(
      title: 'Portfolios',
      value: value,
      valueColor: AppColors.textPrimary,
      icon: Icons.folder_outlined,
      iconColor: AppColors.warning,
      onTap: onTap,
    );
  }

  static Color? _getChangeColor(String? change) {
    if (change == null) return null;
    if (change.startsWith('+')) return AppColors.profit;
    if (change.startsWith('-')) return AppColors.loss;
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final cardPadding = padding ?? const EdgeInsets.all(AppDimensions.paddingM);
    final cardMargin =
        margin ?? const EdgeInsets.symmetric(vertical: AppDimensions.spaceS);
    final cardBorderRadius = borderRadius ?? AppDimensions.radiusM;

    final cardShadow =
        boxShadow ??
        [
          const BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ];

    Widget cardContent = Container(
      padding: cardPadding,
      margin: cardMargin,
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.cardBackground : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: cardShadow,
        border: Border.all(
          color: AppColors.border.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: _buildCardContent(context),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }

  Widget _buildCardContent(BuildContext context) {
    final iconSize = ResponsiveHelper.getResponsiveIconSize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header row with title and icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Icon
            if (icon != null)
              Icon(
                icon,
                size: iconSize * 0.8,
                color: iconColor ?? AppColors.textTertiary,
              ),
          ],
        ),

        const SizedBox(height: AppDimensions.spaceS),

        // Value
        Text(
          value,
          style: _getValueTextStyle(context),
          overflow: TextOverflow.ellipsis,
        ),

        // Subtitle
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            subtitle!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],

        // Change information
        if (change != null || changePercentage != null) ...[
          const SizedBox(height: AppDimensions.spaceXS),
          _buildChangeRow(),
        ],
      ],
    );
  }

  Widget _buildChangeRow() {
    return Row(
      children: [
        // Change amount
        if (change != null)
          Text(
            change!,
            style: AppTextStyles.bodySmall.copyWith(
              color: changeColor ?? AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

        // Spacing between change and percentage
        if (change != null && changePercentage != null)
          const SizedBox(width: AppDimensions.spaceXS),

        // Change percentage
        if (changePercentage != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: (changeColor ?? AppColors.textSecondary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
            child: Text(
              changePercentage!,
              style: AppTextStyles.labelSmall.copyWith(
                color: changeColor ?? AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  TextStyle _getValueTextStyle(BuildContext context) {
    // Responsive font size based on value length and screen size
    double fontSize = AppTextStyles.h3.fontSize!;

    if (ResponsiveHelper.isMobile(context)) {
      // Smaller font for mobile if value is long
      if (value.length > 10) {
        fontSize = AppTextStyles.h4.fontSize!;
      }
    } else {
      // Larger font for tablets/desktop
      fontSize = fontSize * ResponsiveHelper.getFontSizeMultiplier(context);
    }

    return AppTextStyles.h3.copyWith(
      fontSize: fontSize,
      color: valueColor ?? AppColors.textPrimary,
      fontWeight: FontWeight.w700,
    );
  }
}

/// Compact version of portfolio summary card for smaller spaces
class CompactSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? change;
  final Color? valueColor;
  final Color? changeColor;
  final IconData? icon;
  final VoidCallback? onTap;

  const CompactSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.valueColor,
    this.changeColor,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Icon
          if (icon != null) ...[
            Icon(
              icon,
              size: AppDimensions.iconSizeS,
              color: valueColor ?? AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spaceS),
          ],

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: valueColor ?? AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (change != null) ...[
                      const SizedBox(width: AppDimensions.spaceXS),
                      Text(
                        change!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: changeColor ?? AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: content,
      );
    }

    return content;
  }
}
