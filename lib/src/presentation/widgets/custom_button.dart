// lib/src/presentation/widgets/custom_button.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_theme.dart';
import '../../core/utils/responsive_helper.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final bool isOutlined;
  final bool isLoading;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.isOutlined = false,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize,
    this.fontWeight,
  });

  /// Factory for primary button
  factory CustomButton.primary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    bool isLoading = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      width: width,
      isLoading: isLoading,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  /// Factory for outlined button
  factory CustomButton.outlined({
    required String text,
    VoidCallback? onPressed,
    double? width,
    bool isLoading = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      width: width,
      isOutlined: true,
      isLoading: isLoading,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  /// Factory for text button
  factory CustomButton.text({
    required String text,
    VoidCallback? onPressed,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      textColor: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? AppDimensions.buttonHeight;
    final buttonWidth = width ?? ResponsiveHelper.getButtonWidth(context);
    final radius = borderRadius ?? AppDimensions.radiusM;

    // Handle text-only buttons
    if (backgroundColor == Colors.transparent) {
      return _buildTextButton(context, buttonWidth, buttonHeight);
    }

    // Handle outlined buttons
    if (isOutlined) {
      return _buildOutlinedButton(context, buttonWidth, buttonHeight, radius);
    }

    // Handle primary/filled buttons
    return _buildElevatedButton(context, buttonWidth, buttonHeight, radius);
  }

  Widget _buildElevatedButton(
    BuildContext context,
    double buttonWidth,
    double buttonHeight,
    double radius,
  ) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0,
          disabledBackgroundColor: AppColors.grey300,
          disabledForegroundColor: AppColors.grey500,
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildOutlinedButton(
    BuildContext context,
    double buttonWidth,
    double buttonHeight,
    double radius,
  ) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          side: BorderSide(
            color: backgroundColor ?? AppColors.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          disabledForegroundColor: AppColors.grey500,
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    double buttonWidth,
    double buttonHeight,
  ) {
    return SizedBox(
      width: buttonWidth,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          disabledForegroundColor: AppColors.grey500,
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: AppDimensions.iconSizeS,
        width: AppDimensions.iconSizeS,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor ?? Colors.white),
        ),
      );
    }

    final textStyle = AppTextStyles.buttonLarge.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: isOutlined
          ? (textColor ?? AppColors.primary)
          : (textColor ?? Colors.white),
    );

    // Button with icons
    if (prefixIcon != null || suffixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            Icon(
              prefixIcon,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                baseSize: AppDimensions.iconSizeS,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceS),
          ],
          Flexible(
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: AppDimensions.spaceS),
            Icon(
              suffixIcon,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                baseSize: AppDimensions.iconSizeS,
              ),
            ),
          ],
        ],
      );
    }

    // Simple text button
    return Text(
      text,
      style: textStyle,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }
}
