import 'package:flutter/material.dart';
import 'package:wanAndroid/base/BaseWidget.dart';

class TabState<W extends BaseWidget> extends BaseState<W> {
  var children;

  TabState({this.children = const <TabOption>[]})
      : super(
            uiWidget: new TabWidget(tabOptions: children),
            config: ViewConfig(
                hasTitle: true,
                hasBottom: true,
                navigatorKey: GlobalKey<NavigatorState>()));
}

class TabWidget extends UiWidget {
  List<TabOption> tabOptions;
  int _tabIndex = 0;

  get title => this.tabOptions.map((child) => child.title).toList()[_tabIndex];

  get bottomNavItems =>
      this.tabOptions.map((child) => child.navigationBarItem).toList();

  get child => this.tabOptions.map((child) => child.children).toList();

  TabWidget({this.tabOptions});

  get appBar => AppBar(
          title: new Text(
        title,
        style: new TextStyle(color: Colors.white),
      ));

  get _bar => new BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _tabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            if (_tabIndex != index) _tabIndex = index;
          });
        },
      );

  @override
  Widget build(BuildContext context, ViewConfig config) {
    // TODO: implement build
    return MaterialApp(
        navigatorKey: config.navigatorKey,
        theme: ThemeData(),
        home: new Scaffold(
          appBar: this.appBar,
          body: new IndexedStack(
            children: child,
            index: _tabIndex,
          ),
          bottomNavigationBar: _bar,
        ));
  }
}

class TabOption {
  TabOption({this.title, this.children, this.navigationBarItem, this.tabIndex});

  String title;
  Widget children;
  BottomNavigationBarItem navigationBarItem;
  int tabIndex;
}
