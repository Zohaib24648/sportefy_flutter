//lib/presentation/widgets/clickable_text.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';

/// A reusable clickable text component that can either navigate to another page
/// or open a URL. Supports customizable styling and hover effects.
class ClickableText extends StatefulWidget {
  /// The text to display
  final String text;

  /// Optional route name for navigation (use either this or [url])
  final String? routeName;

  /// Optional arguments to pass when navigating
  final Object? routeArguments;

  /// Optional URL to open (use either this or [routeName])
  final String? url;

  /// Custom text style (optional)
  final TextStyle? textStyle;

  /// Whether to show underline decoration
  final bool showUnderline;

  /// Custom onTap callback (overrides route/url behavior if provided)
  final VoidCallback? onTap;

  /// Color for the text (defaults to primary color)
  final Color? color;

  /// Whether the text should be bold
  final bool isBold;

  /// Font size multiplier for responsive sizing
  final double? fontSize;

  /// Whether to show loading indicator on tap
  final bool showLoadingOnTap;

  const ClickableText({
    super.key,
    required this.text,
    this.routeName,
    this.routeArguments,
    this.url,
    this.textStyle,
    this.showUnderline = false,
    this.onTap,
    this.color,
    this.isBold = false,
    this.fontSize,
    this.showLoadingOnTap = false,
  }) : assert(
         (routeName != null && url == null) ||
             (routeName == null && url != null) ||
             (routeName == null && url == null && onTap != null),
         'Either routeName, url, or onTap must be provided (but not multiple)',
       );

  @override
  State<ClickableText> createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppColors.primaryColor;
    final effectiveFontSize = widget.fontSize ?? 14;

    TextStyle defaultStyle = TextStyle(
      color: effectiveColor,
      fontSize: ResponsiveHelper.getResponsiveFontSize(
        context,
        effectiveFontSize,
      ),
      fontFamily: 'Lexend',
      fontWeight: widget.isBold ? FontWeight.w600 : FontWeight.w400,
      decoration: widget.showUnderline
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationColor: effectiveColor,
    );

    final finalStyle =
        widget.textStyle?.copyWith(
          color: widget.textStyle?.color ?? effectiveColor,
          fontSize:
              widget.textStyle?.fontSize ??
              ResponsiveHelper.getResponsiveFontSize(
                context,
                effectiveFontSize,
              ),
        ) ??
        defaultStyle;

    return GestureDetector(
      onTap: _isLoading ? null : _handleTap,
      child: _isLoading && widget.showLoadingOnTap
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.text,
                  style: finalStyle.copyWith(
                    color: finalStyle.color?.withValues(alpha: .6),
                  ),
                ),
              ],
            )
          : Text(widget.text, style: finalStyle),
    );
  }

  void _handleTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    if (widget.showLoadingOnTap) {
      setState(() => _isLoading = true);
    }

    try {
      if (widget.routeName != null) {
        await _navigateToRoute();
      } else if (widget.url != null) {
        await _openUrl();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to complete action: $e');
    } finally {
      if (mounted && widget.showLoadingOnTap) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _navigateToRoute() async {
    if (!mounted) return;

    Navigator.of(
      context,
    ).pushNamed(widget.routeName!, arguments: widget.routeArguments);
  }

  Future<void> _openUrl() async {
    final uri = Uri.parse(widget.url!);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch ${widget.url}';
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
