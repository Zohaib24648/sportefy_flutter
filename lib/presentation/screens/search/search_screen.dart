import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/shimmer_exports.dart';
import '../../widgets/search/search_widgets.dart';
import '../../../bloc/search/search_bloc_exports.dart';
import '../../../dependency_injection.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>(),
      child: const SearchScreenView(),
    );
  }
}

class SearchScreenView extends StatelessWidget {
  const SearchScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  EnhancedSearchBar(
                    onChanged: (query) {
                      context.read<SearchBloc>().add(SearchQueryChanged(query));
                    },
                    onSubmitted: (query) {
                      context.read<SearchBloc>().add(SearchSubmitted(query));
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildSearchContent(state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchContent(SearchState state) {
    return switch (state) {
      SearchInitial() => const Center(
        child: Text(
          'Enter a search term to begin',
          style: TextStyle(color: Colors.white),
        ),
      ),
      SearchTyping() => const Center(
        child: Text('Type to search...', style: TextStyle(color: Colors.white)),
      ),
      SearchLoading() => AppShimmer(
        child: Container(
          height: 200,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
      SearchSuccess() =>
        state.results.isEmpty
            ? Center(
                child: Text(
                  'No results found for "${state.query}"',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : const Center(
                child: Text(
                  'Search results would go here',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      SearchFailure() => Center(
        child: Text(
          'Error: ${state.error}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      _ => const Center(
        child: Text('Unknown state', style: TextStyle(color: Colors.white)),
      ),
    };
  }
}
