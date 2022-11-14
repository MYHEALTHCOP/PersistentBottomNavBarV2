part of persistent_bottom_nav_bar_v2;

class CustomTabView extends StatefulWidget {
  final NavigatorConfig navigatorConfig;

  final WidgetBuilder? home;

  const CustomTabView({
    Key? key,
    this.home,
    required this.navigatorConfig,
  }) : super(key: key);

  @override
  _CustomTabViewState createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  HeroController _heroController = CupertinoApp.createCupertinoHeroController();
  late List<NavigatorObserver?> _navigatorObservers;

  @override
  void initState() {
    super.initState();
    _updateObservers();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigatorConfig.navigatorKey !=
            oldWidget.navigatorConfig.navigatorKey ||
        widget.navigatorConfig.navigatorObservers !=
            oldWidget.navigatorConfig.navigatorObservers) {
      _updateObservers();
    }
  }

  void _updateObservers() {
    _navigatorObservers =
        List<NavigatorObserver>.from(widget.navigatorConfig.navigatorObservers)
          ..add(_heroController);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorConfig.navigatorKey,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
      observers: _navigatorObservers as List<NavigatorObserver>,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final String? name = settings.name;
    final WidgetBuilder? pageContentBuilder =
        name == Navigator.defaultRouteName && widget.home != null
            ? widget.home
            : widget.navigatorConfig.routes[name];

    if (pageContentBuilder != null) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            pageContentBuilder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
        settings: settings,
      );
    }
    Route? rootNavigatorRoute = Navigator.of(context, rootNavigator: true)
        .widget
        .onGenerateRoute
        ?.call(settings);
    if (rootNavigatorRoute != null) {
      return rootNavigatorRoute;
    }
    if (widget.navigatorConfig.onGenerateRoute != null)
      return widget.navigatorConfig.onGenerateRoute!(settings);
    return null;
  }

  Route<dynamic>? _onUnknownRoute(RouteSettings settings) {
    assert(() {
      if (widget.navigatorConfig.onUnknownRoute == null) {
        throw FlutterError(
            'Could not find a generator for route $settings in the $runtimeType.\n'
            'Generators for routes are searched for in the following order:\n'
            ' 1. For the "/" route, the "builder" property, if non-null, is used.\n'
            ' 2. Otherwise, the "routes" table is used, if it has an entry for '
            'the route.\n'
            ' 3. Otherwise, onGenerateRoute is called. It should return a '
            'non-null value for any valid route not handled by "builder" and "routes".\n'
            ' 4. Finally if all else fails onUnknownRoute is called.\n'
            'Unfortunately, onUnknownRoute was not set.');
      }
      return true;
    }());
    final Route<dynamic>? result =
        widget.navigatorConfig.onUnknownRoute!(settings);
    assert(() {
      if (result == null) {
        throw FlutterError('The onUnknownRoute callback returned null.\n'
            'When the $runtimeType requested the route $settings from its '
            'onUnknownRoute callback, the callback returned null. Such callbacks '
            'must never return null.');
      }
      return true;
    }());
    return result;
  }
}
