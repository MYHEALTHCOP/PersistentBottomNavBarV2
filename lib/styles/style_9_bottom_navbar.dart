part of persistent_bottom_nav_bar_v2;

class Style9BottomNavBar extends StatefulWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimation itemAnimationProperties;

  Style9BottomNavBar({
    Key? key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
  });

  @override
  _Style9BottomNavBarState createState() => _Style9BottomNavBarState();
}

class _Style9BottomNavBarState extends State<Style9BottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllerList;
  late List<Animation<Offset>> _animationList;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.navBarConfig.selectedIndex;
    _animationControllerList = List<AnimationController>.empty(growable: true);
    _animationList = List<Animation<Offset>>.empty(growable: true);

    for (int i = 0; i < widget.navBarConfig.items.length; ++i) {
      _animationControllerList.add(AnimationController(
          duration: widget.itemAnimationProperties.duration, vsync: this));
      _animationList.add(Tween(
              begin: Offset(0, widget.navBarConfig.navBarHeight),
              end: Offset(0, 0.0))
          .chain(CurveTween(curve: widget.itemAnimationProperties.curve))
          .animate(_animationControllerList[i]));
    }

    _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
      _animationControllerList[_selectedIndex].forward();
    });
  }

  Widget _buildItem(ItemConfig item, bool isSelected, int itemIndex) {
    return AnimatedBuilder(
      animation: _animationList[itemIndex],
      builder: (context, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: isSelected
                    ? item.activeColorPrimary
                    : item.inactiveColorPrimary,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
          if (item.title != null)
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: widget.itemAnimationProperties.duration,
              child: Transform.translate(
                offset: _animationList[itemIndex].value,
                child: FittedBox(
                  child: Text(
                    item.title!,
                    style: item.textStyle.apply(
                      color: isSelected
                          ? item.activeColorPrimary
                          : item.inactiveColorPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationControllerList.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.navBarConfig.selectedIndex != _selectedIndex) {
      _animationControllerList[_selectedIndex].reverse();
      _selectedIndex = widget.navBarConfig.selectedIndex;
      _animationControllerList[_selectedIndex].forward();
    }
    return DecoratedNavBar(
      decoration: widget.navBarDecoration,
      filter: widget.navBarConfig.items[_selectedIndex].filter,
      opacity: widget.navBarConfig.items[_selectedIndex].opacity,
      height: widget.navBarConfig.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.navBarConfig.items.map((item) {
          int index = widget.navBarConfig.items.indexOf(item);
          return Expanded(
            child: InkWell(
              onTap: () {
                widget.navBarConfig.onItemSelected(index);
              },
              child: _buildItem(
                item,
                widget.navBarConfig.selectedIndex == index,
                index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
