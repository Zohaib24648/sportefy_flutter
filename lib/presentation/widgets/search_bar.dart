import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final Color? backgroundColor;
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
    Key? key,
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
    this.backgroundColor,
    this.borderColor,
    this.height = 52,
    this.padding,
    this.borderRadius,
    this.hintStyle,
    this.textStyle,
    this.showShadow = true,
    this.suggestions,
    this.showSearchIcon = true,
  }) : super(key: key);

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
              color: widget.backgroundColor ?? Colors.white.withOpacity(0.9),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              border: Border.all(
                color:
                    Color.lerp(
                      widget.borderColor ?? Colors.transparent,
                      theme.primaryColor,
                      _focusAnimation.value,
                    ) ??
                    Colors.transparent,
                width: 2,
              ),
              boxShadow: widget.showShadow
                  ? [
                      BoxShadow(
                        color: Color.lerp(
                          Colors.black.withOpacity(0.05),
                          theme.primaryColor.withOpacity(0.1),
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
                  widget.textStyle ??
                  TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 14,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                  ),
              onSubmitted: (value) {
                _removeSuggestionsOverlay();
                widget.onSubmitted?.call(value);
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle:
                    widget.hintStyle ??
                    TextStyle(
                      color: Colors.black.withOpacity(0.48),
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
          color: Colors.grey[600],
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
    Key? key,
    required this.animation,
    required this.isFocused,
  }) : super(key: key);

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
                Colors.grey[600],
                theme.primaryColor,
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
    Key? key,
    required this.suggestions,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: Colors.white,
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
                      color: Colors.grey.withOpacity(0.2),
                      width: index == suggestions.length - 1 ? 0 : 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.grey[600],
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

// Usage Examples
class SearchBarExamples extends StatefulWidget {
  const SearchBarExamples({Key? key}) : super(key: key);

  @override
  State<SearchBarExamples> createState() => _SearchBarExamplesState();
}

class _SearchBarExamplesState extends State<SearchBarExamples> {
  String searchQuery = '';

  final List<String> venueSuggestions = [
    'Red Meadows Sports Complex',
    'Green Valley Tennis Courts',
    'Blue Sky Basketball Arena',
    'Golden Gate Football Field',
    'Silver Lake Badminton Hall',
    'Crystal Palace Swimming Pool',
    'Diamond Ridge Golf Course',
    'Sunset Beach Volleyball Court',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Search Bar Examples'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Basic Search Bar'),
            EnhancedSearchBar(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              onSubmitted: (value) {
                _showSnackBar('Searched for: $value');
              },
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Search with Suggestions'),
            EnhancedSearchBar(
              hintText: 'Search venues...',
              suggestions: venueSuggestions,
              onSubmitted: (value) {
                _showSnackBar('Selected: $value');
              },
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Custom Styled Search'),
            EnhancedSearchBar(
              hintText: 'Find your favorite sport...',
              backgroundColor: Colors.purple.withOpacity(0.1),
              borderColor: Colors.purple.withOpacity(0.3),
              height: 60,
              borderRadius: BorderRadius.circular(30),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 16),
                child: const Icon(
                  Icons.sports_basketball,
                  color: Colors.purple,
                ),
              ),
              hintStyle: TextStyle(
                color: Colors.purple.withOpacity(0.6),
                fontSize: 16,
              ),
              textStyle: const TextStyle(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Minimal Search (No Shadow)'),
            EnhancedSearchBar(
              hintText: 'Quick search...',
              showShadow: false,
              backgroundColor: Colors.grey[200],
              showSearchIcon: false,
              height: 48,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Search with Custom Icons'),
            EnhancedSearchBar(
              hintText: 'Location search...',
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 16),
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  _showSnackBar('Filter clicked');
                },
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Current Search Query'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Text(
                searchQuery.isEmpty
                    ? 'No search query'
                    : 'Searching for: "$searchQuery"',
                style: TextStyle(
                  color: searchQuery.isEmpty ? Colors.grey : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
