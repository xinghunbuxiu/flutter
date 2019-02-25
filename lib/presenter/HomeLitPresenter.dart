import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wanAndroid/base/BaseWidget.dart';
import 'package:wanAndroid/base/Presenter.dart';
import 'package:wanAndroid/http/Api.dart';
import 'package:wanAndroid/http/HttpUtil.dart';
import 'package:wanAndroid/item/ArticleItem.dart';
import 'package:wanAndroid/widget/PageLoad.dart';
import 'package:wanAndroid/widget/SlideView.dart';

class HomeListPresenter extends Presenter {
  void getBanner() {
    String bannerUrl = Api.BANNER;

    HttpUtil.get(bannerUrl, (result) {
      if (result != null) {
        print(state);
        print("getBanner");
        state.notifyData(Message(action: 0, data: result));
      }
    });
  }

  void getHomeArticlelist(int curPage) {
    String url = Api.ARTICLE_LIST;
    url += "$curPage/json";

    HttpUtil.get(url, (result) {
      if (result != null) {
        print(state);
        print("getHomeArticlelist");

        state.notifyData(Message(action: 0, data: result));
      }
    });
  }
}

class HomeListWidget extends UiWidget<HomeListPresenter> {
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0);
  TextStyle subtitleTextStyle =
      new TextStyle(color: Colors.blue, fontSize: 12.0);
  BaseQuickAdapter _adapter;
  var bannerData = new List();

  HomeListWidget() {
    _adapter = new BaseQuickAdapter(
        headers: [
          new HeaderAndFooterItemWidget(
              t: bannerData,
              itemBuilder: (context, t) {
                return new Container(
                  child: SlideView(t),
                  height: 180,
                );
              })
        ],
        itemBuilder: (context, t) {
          print("ccccccccccccccccccccccccccccccccc");
          print(t);
          return new ArticleItem(t);
        },
        onLoad: (int page) {
          if (page == 0) {
            presenter.getBanner();
          }
          presenter.getHomeArticlelist(page);
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adapter.start();
  }

  @override
  void dispose() {
    _adapter.dispose();
    super.dispose();
  }

  void notifyData(Message msg) {
    print(msg.data);
    print(msg.action);
    switch (msg.action) {
      case 0:
        setState(() {
          bannerData = msg.data;
        });
        break;
      case 1:
        setState(() {
          Map<String, dynamic> map = msg.data;
          var _listData = map['datas'];
          setState(() {
            _adapter.addData(_listData);
          });
        });
        break;
    }
  }
}
