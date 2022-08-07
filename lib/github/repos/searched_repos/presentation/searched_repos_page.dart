import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../auth/shared/providers.dart';
import '../../../../core/presentation/routes/app_router.gr.dart';
import '../../../core/shared/providers.dart';
import '../../core/presentation/paginated_repos_list_view.dart';
import '../../../../search/presentation/search_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchedReposPage extends ConsumerStatefulWidget {
  final String searchTerm;

  const SearchedReposPage({
    Key? key,
    required this.searchTerm,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchedReposPageState();
}

class _SearchedReposPageState extends ConsumerState<SearchedReposPage> {
  @override
  void initState() {
    super.initState();
    // ref.read(searchedReposNotifierProvider.notifier).getNextStarredReposPage();
    Future.microtask(
      () => ref
          .read(searchedReposNotifierProvider.notifier)
          .getFirstSearchedReposPage(widget.searchTerm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchBar(
        title: widget.searchTerm,
        hint: 'Search all repositories...',
        onShouldNavigateToResultPage: (searchTerm) {
          AutoRouter.of(context).pushAndPopUntil(
            SearchedReposRoute(searchTerm: searchTerm),
            predicate: (route) => route.settings.name == StarredReposRoute.name,
          );
        },
        onSignOutButtonPressed: () {
          // ref.read(authNotifierProvider.notifier).signOut();
          ref.read(authNotifierProvider.notifier).signOut();
        },
        body: PaginatedReposListView(
          paginatedReposNotifierProvider: searchedReposNotifierProvider,
          getNextPage: (/*ref*/ ref) {
            // ref
            //     .read(searchedReposNotifierProvider.notifier)
            //     .getNextStarredReposPage();
            ref
                .read(searchedReposNotifierProvider.notifier)
                .getNextSearchedReposPage(widget.searchTerm);
          },
          noResultsMessage:
              "This is all we could find for your search term. Really...",
        ),
      ),
    );
  }
}
