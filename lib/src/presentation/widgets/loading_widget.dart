// lib/src/presentation/widgets/loading_widget.dart

import 'package:flutter/material.dart';

import '../../core/constants/app_theme.dart';
import '../../core/utils/responsive_helper.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? size;
  final double? strokeWidth;
  final bool showMessage;
  final EdgeInsets? padding;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size,
    this.strokeWidth,
    this.showMessage = false,
    this.padding,
  });

  /// Factory for full screen loading
  factory LoadingWidget.fullScreen({String? message, Color? backgroundColor}) {
    return LoadingWidget(
      message: message,
      showMessage: true,
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
    );
  }

  /// Factory for inline loading (small)
  factory LoadingWidget.inline({Color? color, double? size}) {
    return LoadingWidget(
      color: color,
      size: size ?? AppDimensions.iconSizeS,
      strokeWidth: 2,
    );
  }

  /// Factory for button loading
  factory LoadingWidget.button({Color? color}) {
    return LoadingWidget(
      color: color ?? Colors.white,
      size: AppDimensions.iconSizeS,
      strokeWidth: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadingSize = size ?? AppDimensions.iconSizeL;
    final loadingColor = color ?? AppColors.primary;
    final loadingStrokeWidth = strokeWidth ?? 3.0;

    Widget loadingIndicator = SizedBox(
      width: loadingSize,
      height: loadingSize,
      child: CircularProgressIndicator(
        color: loadingColor,
        strokeWidth: loadingStrokeWidth,
      ),
    );

    // If no message, just return the indicator
    if (!showMessage || message == null) {
      return padding != null
          ? Padding(padding: padding!, child: loadingIndicator)
          : loadingIndicator;
    }

    // Return indicator with message
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadingIndicator,
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            message!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black54,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXL),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: LoadingWidget.fullScreen(message: message),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shimmer loading effect for placeholders
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? duration;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppColors.grey200;
    final highlightColor = widget.highlightColor ?? AppColors.grey100;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [0.0, 0.5, 1.0],
              transform: GradientRotation(_animation.value * 3.14159),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Simple shimmer placeholder for cards
class ShimmerCard extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const ShimmerCard({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 80,
      width: width,
      margin:
          margin ??
          const EdgeInsets.symmetric(
            vertical: AppDimensions.spaceS,
            horizontal: AppDimensions.paddingM,
          ),
      child: ShimmerLoading(
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Container(
                height: 12,
                width: ResponsiveHelper.responsiveSize(context, 60),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
