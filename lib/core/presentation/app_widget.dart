import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/shared/providers.dart';
import 'routes/app_router.gr.dart';
import '../shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final initializationProvider = FutureProvider<Unit>((ref) async {
  await ref.read(sembastProvider).init();
  ref.read(dioProvider)
    ..options = BaseOptions(
      headers: {
        'Accept': 'application/vnd.github.v3.html+json',
      },
      validateStatus: (status) =>
          status != null && status >= 200 && status < 400,
    )
    ..interceptors.add(ref.read(oAuth2InterceptorProvider));
  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.checkAndUpdateAuthStatus();
  return unit;
});

class AppWidget extends ConsumerWidget {
  final appRouter = AppRouter();

  AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(initializationProvider, (previous, next) {});
    ref.listen<AuthState>(authNotifierProvider, ((previous, next) {
      next.maybeMap(
          orElse: () {},
          authenticated: (_) {
            appRouter.pushAndPopUntil(
              const StarredReposRoute(),
              predicate: (route) => false,
            );
          },
          unauthenticated: (_) {
            appRouter.pushAndPopUntil(
              const SignInRoute(),
              predicate: (route) => false,
            );
          });
    }));
    // ref.listen<AuthState>(authNotifier, (state) {

    // });
    return MaterialApp.router(
      title: 'Repo Viewer',
      theme: _setUpThemeData(),
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }

  ThemeData _setUpThemeData() {
    return ThemeData(
      primaryColor: Colors.grey.shade50,
    );
  }
}
