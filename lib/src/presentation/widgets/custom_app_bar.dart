// lib/src/presentation/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_theme.dart';
import '../../core/utils/responsive_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? titleSpacing;
  final double? leadingWidth;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.systemOverlayStyle,
    this.titleSpacing,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
  });

  /// Factory for simple title app bar
  factory CustomAppBar.simple({
    required String title,
    List<Widget>? actions,
    bool centerTitle = true,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  /// Factory for app bar with back button
  factory CustomAppBar.withBackButton({
    required String title,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    bool centerTitle = true,
  }) {
    return CustomAppBar(
      title: title,
      showBackButton: true,
      onBackPressed: onBackPressed,
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  /// Factory for transparent app bar
  factory CustomAppBar.transparent({
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    bool showBackButton = false,
    VoidCallback? onBackPressed,
    Color? foregroundColor,
  }) {
    return CustomAppBar(
      title: title,
      titleWidget: titleWidget,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      actions: actions,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor,
      elevation: 0,
    );
  }

  /// Factory for search app bar
  factory CustomAppBar.search({
    required Widget searchWidget,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      titleWidget: searchWidget,
      showBackButton: true,
      onBackPressed: onBackPressed,
      actions: actions,
      centerTitle: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(context),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? AppColors.background,
      foregroundColor: foregroundColor ?? AppColors.textPrimary,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      toolbarHeight: ResponsiveHelper.getAppBarHeight(context),
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(),

      // Consistent styling
      titleTextStyle: _getTitleTextStyle(context),
      iconTheme: IconThemeData(
        color: foregroundColor ?? AppColors.textPrimary,
        size: ResponsiveHelper.getResponsiveIconSize(context),
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? AppColors.textPrimary,
        size: ResponsiveHelper.getResponsiveIconSize(context),
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (titleWidget != null) {
      return titleWidget;
    }

    if (title != null) {
      return Text(
        title!,
        style: _getTitleTextStyle(context),
        overflow: TextOverflow.ellipsis,
      );
    }

    return null;
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }

    if (showBackButton) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: ResponsiveHelper.getResponsiveIconSize(context),
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null || actions!.isEmpty) {
      return null;
    }

    return actions!.map((action) {
      // Add consistent padding to actions
      return Padding(
        padding: const EdgeInsets.only(right: AppDimensions.paddingS),
        child: action,
      );
    }).toList();
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    final baseStyle = AppTextStyles.h4;
    final multiplier = ResponsiveHelper.getFontSizeMultiplier(context);

    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize! * multiplier,
      color: foregroundColor ?? AppColors.textPrimary,
    );
  }

  SystemUiOverlayStyle _getSystemOverlayStyle() {
    final isDark =
        backgroundColor == Colors.black || backgroundColor == AppColors.grey900;

    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor ?? AppColors.background,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);
}

/// Custom App Bar with search functionality
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final TextEditingController? controller;
  final bool autofocus;

  const SearchAppBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onBackPressed,
    this.actions,
    this.controller,
    this.autofocus = true,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: widget.onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search...',
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textHint,
          ),
          border: InputBorder.none,
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: _onClear)
              : null,
        ),
        onChanged: (value) {
          setState(() {}); // Rebuild to show/hide clear button
          widget.onChanged?.call(value);
        },
        onSubmitted: widget.onSubmitted,
      ),
      actions: widget.actions,
    );
  }
}
