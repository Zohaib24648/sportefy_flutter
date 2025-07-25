import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

// Enhanced Search Bar Widget
class EnhancedSearchBar extends StatefulWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final VoidCallback? onClear;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool autofocus;
  final Color? white;
  final Color? borderColor;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final bool showShadow;
  final List<String>? suggestions;
  final bool showSearchIcon;

  const EnhancedSearchBar({
    super.key,
    this.hintText = 'Search by Venue or Location',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.autofocus = false,
    this.white,
    this.borderColor,
    this.height = 52,
    this.padding,
    this.borderRadius,
    this.hintStyle,
    this.textStyle,
    this.showShadow = true,
    this.suggestions,
    this.showSearchIcon = true,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;
  bool _hasText = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _removeSuggestionsOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }

    if (widget.suggestions != null && _isFocused) {
      _showSuggestionsOverlay();
    }
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
      widget.onTap?.call();
      if (widget.suggestions != null && _controller.text.isNotEmpty) {
        _showSuggestionsOverlay();
      }
    } else {
      _animationController.reverse();
      _removeSuggestionsOverlay();
    }
  }

  void _showSuggestionsOverlay() {
    _removeSuggestionsOverlay();

    final filteredSuggestions = widget.suggestions!
        .where(
          (suggestion) =>
              suggestion.toLowerCase().contains(_controller.text.toLowerCase()),
        )
        .toList();

    if (filteredSuggestions.isEmpty || _controller.text.isEmpty) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, widget.height! + 8),
          child: _SuggestionsOverlay(
            suggestions: filteredSuggestions,
            onSuggestionTap: (suggestion) {
              _controller.text = suggestion;
              _removeSuggestionsOverlay();
              _focusNode.unfocus();
              widget.onSubmitted?.call(suggestion);
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeSuggestionsOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: AnimatedBuilder(
        animation: _focusAnimation,
        builder: (context, child) {
          return Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.white ?? AppColors.white.withValues(alpha: 0.9),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              border: Border.all(
                color:
                    Color.lerp(
                      widget.borderColor ?? Colors.transparent,
                      theme.colorScheme.primary,
                      _focusAnimation.value,
                    ) ??
                    Colors.transparent,
                width: 2,
              ),
              boxShadow: widget.showShadow
                  ? [
                      BoxShadow(
                        color: Color.lerp(
                          AppColors.shadow,
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                          _focusAnimation.value,
                        )!,
                        blurRadius: 10 + (_focusAnimation.value * 5),
                        offset: Offset(0, 2 + (_focusAnimation.value * 2)),
                      ),
                    ]
                  : null,
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              maxLength: widget.maxLength,
              autofocus: widget.autofocus,
              style:
                  widget.textStyle ?? AppTextStyles.body.copyWith(fontSize: 14),
              onSubmitted: (value) {
                _removeSuggestionsOverlay();
                widget.onSubmitted?.call(value);
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle:
                    widget.hintStyle ??
                    TextStyle(
                      color: AppColors.grey.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w300,
                    ),
                prefixIcon:
                    widget.prefixIcon ??
                    (widget.showSearchIcon
                        ? AnimatedSearchIcon(
                            animation: _focusAnimation,
                            isFocused: _isFocused,
                          )
                        : null),
                suffixIcon: _buildSuffixIcon(),
                border: InputBorder.none,
                contentPadding:
                    widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                counterText: '',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }

    if (_hasText) {
      return AnimatedOpacity(
        opacity: _hasText ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          icon: const Icon(Icons.clear, size: 20),
          onPressed: () {
            _controller.clear();
            widget.onClear?.call();
            _removeSuggestionsOverlay();
          },
          color: AppColors.grey,
        ),
      );
    }

    return null;
  }
}

// Animated Search Icon
class AnimatedSearchIcon extends StatelessWidget {
  final Animation<double> animation;
  final bool isFocused;

  const AnimatedSearchIcon({
    super.key,
    required this.animation,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(left: 12),
          child: Transform.rotate(
            angle: animation.value * 0.5,
            child: Icon(
              Icons.search,
              size: 24,
              color: Color.lerp(
                AppColors.grey,
                theme.colorScheme.primary,
                animation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Suggestions Overlay
class _SuggestionsOverlay extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;

  const _SuggestionsOverlay({
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return InkWell(
              onTap: () => onSuggestionTap(suggestion),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.lightGrey.withValues(alpha: 0.5),
                      width: index == suggestions.length - 1 ? 0 : 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
