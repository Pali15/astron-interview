import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:template/domain/github/bloc/github_repository_bloc.dart';
import 'package:template/presentation/home_page/home.dart';
import 'package:template/presentation/home_page/home_nested.dart';
import 'package:template/presentation/profile_page/profile.dart';
import 'package:template/router/route_wrapper.dart';
import 'package:template/router/routes.dart';
import 'package:template/widgets/bottom_navbar.dart';

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final RoutesBuilder _builder;
  late final GoRouter _router;

  GoRouter get router => _router;

  AppRouter(RoutesBuilder builder) {
    _builder = builder;
    _router = GoRouter(
      initialLocation: AppRoutes.home,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => BottomNavbar(
            navigationShell: navigationShell,
          ),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  name: AppRoutes.home,
                  builder: _builder.homePageBuilder,
                  routes: [
                    GoRoute(
                      path: AppRoutes.homeNested,
                      name: AppRoutes.homeNested,
                      builder: _builder.homeNestedPageBuilder,
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  name: AppRoutes.profile,
                  builder: _builder.profilePageBuilder,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class RoutesBuilder {
  final GithubRepositoryBloc githubRepositoryBloc;

  RoutesBuilder({
    required this.githubRepositoryBloc,
  });

  Widget homePageBuilder(BuildContext context, GoRouterState state) {
    return RouteWrapper(
      child: BlocProvider<GithubRepositoryBloc>.value(
        value: githubRepositoryBloc,
        child: HomePage(),
      ),
    );
  }

  Widget homeNestedPageBuilder(BuildContext context, GoRouterState state) {
    return RouteWrapper(child: HomeNested());
  }

  Widget profilePageBuilder(BuildContext context, GoRouterState state) {
    return RouteWrapper(child: ProfilePage());
  }
}
