part of persistent_bottom_nav_bar_v2;

class BottomNavStyle16 extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  BottomNavStyle16({
    Key? key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  })  : assert(navBarConfig.items.length % 2 == 1,
            "The number of items must be odd for this style"),
        super(key: key);

  Widget _buildItem(ItemConfig item, bool isSelected) {
    return Column(
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
          FittedBox(
            child: Text(
              item.title!,
              style: item.textStyle.apply(
                  color: isSelected
                      ? item.activeColorPrimary
                      : item.inactiveColorPrimary),
            ),
          ),
      ],
    );
  }

  Widget _buildMiddleItem(
      BuildContext context, ItemConfig item, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(
        left: 5.0,
        right: 5.0,
      ),
      decoration: BoxDecoration(
        color: item.activeColorPrimary,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: this.navBarDecoration.decoration?.boxShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: item.activeColorPrimary,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
          if (item.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FittedBox(
                  child: Text(
                    item.title!,
                    style: item.textStyle.apply(
                        color: isSelected
                            ? item.activeColorPrimary
                            : item.inactiveColorPrimary),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final midIndex = (this.navBarConfig.items.length / 2).floor();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 23,
            ),
            DecoratedNavBar(
              decoration: this.navBarDecoration,
              filter: this.navBarConfig.selectedItem.filter,
              opacity: this.navBarConfig.selectedItem.opacity,
              height: this.navBarConfig.navBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: this.navBarConfig.items.map((item) {
                  int index = this.navBarConfig.items.indexOf(item);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        this.navBarConfig.onItemSelected(index);
                      },
                      child: index == midIndex
                          ? Container(width: 150, color: Colors.transparent)
                          : _buildItem(
                              item,
                              this.navBarConfig.selectedIndex == index,
                            ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                this.navBarConfig.onItemSelected(midIndex);
              },
              child: _buildMiddleItem(
                context,
                this.navBarConfig.items[midIndex],
                this.navBarConfig.selectedIndex == midIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
