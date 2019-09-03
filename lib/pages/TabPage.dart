import 'package:flutter/material.dart';
import 'package:wanAndroid/State/TabState.dart';
import 'package:wanAndroid/base/BaseWidget.dart';
import 'package:wanAndroid/pages/HomeListPage.dart';
import 'package:wanAndroid/pages/MyInfoPage.dart';
import 'package:wanAndroid/pages/TreePage.dart';

//主页
class TabPage extends BaseWidget {
  @override
  _WanAndroidAppState createState() => _WanAndroidAppState();
}

class _WanAndroidAppState extends TabState<TabPage>
    with TickerProviderStateMixin {
  _WanAndroidAppState({appBarTitles: const ['首页', '发现', '我的']})
      : super(tabOptions: [
          new TabOption(
              title: appBarTitles[0],
              children: HomeListPage(),
              navigationBarItem: BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                title: new Text(appBarTitles[0]),
                backgroundColor: Colors.blue,
              )),
          new TabOption(
              title: appBarTitles[1],
              children: TreePage(),
              navigationBarItem: BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                title: new Text(appBarTitles[1]),
                backgroundColor: Colors.blue,
              )),
          new TabOption(
              title: appBarTitles[2],
              children: MyInfoPage(),
              navigationBarItem: BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                title: new Text(appBarTitles[2]),
                backgroundColor: Colors.blue,
              ))
        ]);
}
