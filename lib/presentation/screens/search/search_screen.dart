import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/common/shimmer_exports.dart';
import '../../widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isSearching = false;
  bool _hasSearched = false;

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      _hasSearched = true;
      _isSearching = false;
    });
    // TODO: Implement actual search functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: EnhancedSearchBar(
              hintText: 'Search for venues, sports, events...',
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
              white: Colors.white,
              showShadow: true,
            ),
          ),

          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching) {
      // Show loading shimmer while typing/searching
      return const Padding(
        padding: EdgeInsets.all(16),
        child: SearchResultShimmer(),
      );
    } else if (_hasSearched) {
      // Show search results (placeholder for now)
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Try searching for something else',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    } else {
      // Show initial state
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'Search for Sports',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Find venues, sports, events, and more!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}
