import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../auth/shared/providers.dart';
import '../../../../core/presentation/routes/app_router.gr.dart';
import '../../../core/shared/providers.dart';
import '../../core/presentation/paginated_repos_list_view.dart';
import '../../../../search/presentation/search_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StarredReposPage extends ConsumerStatefulWidget {
  const StarredReposPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StarredReposPageState();
}

class _StarredReposPageState
    extends ConsumerState<StarredReposPage> /*with ConsumerStateMixin*/ {
  @override
  void initState() {
    super.initState();
    // ref.read(starredReposNotifierProvider.notifier).getNextStarredReposPage();
    Future.microtask(
      () => ref
          .read(starredReposNotifierProvider.notifier)
          .getNextStarredReposPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchBar(
        title: 'Starred repositories',
        hint: 'Search all repositories...',
        onShouldNavigateToResultPage: (searchTerm) {
          AutoRouter.of(context)
              .push(SearchedReposRoute(searchTerm: searchTerm));
        },
        onSignOutButtonPressed: () {
          // ref.read(authNotifierProvider.notifier).signOut();
          ref.read(authNotifierProvider.notifier).signOut();
        },
        body: PaginatedReposListView(
          paginatedReposNotifierProvider: starredReposNotifierProvider,
          getNextPage: (/*ref*/ context) {
            // ref
            //     .read(starredReposNotifierProvider.notifier)
            //     .getNextStarredReposPage();
            context
                .read(starredReposNotifierProvider.notifier)
                .getNextStarredReposPage();
          },
          noResultsMessage:
              "That's about everything we could find in your starred repos right now.",
        ),
      ),
    );
  }
}
