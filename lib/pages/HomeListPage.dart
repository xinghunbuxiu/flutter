import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wanAndroid/base/BaseWidget.dart';
import 'package:wanAndroid/constant/Constants.dart';
import 'package:wanAndroid/http/Api.dart';
import 'package:wanAndroid/http/HttpUtilWithCookie.dart';
import 'package:wanAndroid/item/ArticleItem.dart';
import 'package:wanAndroid/presenter/HomeLitPresenter.dart';
import 'package:wanAndroid/widget/EndLine.dart';
import 'package:wanAndroid/widget/PageLoad.dart';
import 'package:wanAndroid/widget/SlideView.dart';

class HomeListPage extends BaseWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeListPageState();
  }
}

class HomeListPageState extends BaseState<HomeListPage> {

  HomeListPageState() : super(uiWidget: new HomeListWidget());

  @override
  void initState() {
    super.initState();
    uiWidget.initState();
  }

  @override
  void dispose() {
    uiWidget.dispose();
    super.dispose();
  }

  void notifyData(Message msg) {
    print(msg.data);
    print(msg.action);
    uiWidget.notifyData(msg);
  }
}
