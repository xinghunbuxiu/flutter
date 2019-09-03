import 'package:flutter/material.dart';
import 'package:wanAndroid/base/BaseWidget.dart';
import 'package:wanAndroid/base/Presenter.dart';
import 'package:wanAndroid/http/Api.dart';
import 'package:wanAndroid/http/HttpUtilWithCookie.dart';
import 'package:wanAndroid/item/ArticleItem.dart';
import 'package:wanAndroid/widget/PageLoad.dart';
import 'package:wanAndroid/widget/SlideView.dart';

class HomeListPage extends BaseWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeListState();
  }
}

class HomeListPresenter extends Presenter {
  void getBanner() {
    String bannerUrl = Api.BANNER;

    HttpUtil.get(bannerUrl, (result) {
      if (result != null) {
        state.notify(Message(action: 0, data: result));
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
        print(result);
        state.notify(Message(action: 1, data: result));
      }
    });
  }
}

class HomeListState extends BaseState<HomeListPage, HomeListPresenter> {
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0);
  TextStyle subtitleTextStyle =
      new TextStyle(color: Colors.blue, fontSize: 12.0);
  BaseQuickAdapter _adapter;

  HomeListState() : super(p: new HomeListPresenter()) {
    _adapter = new BaseQuickAdapter(headerBuilder: (context, t) {
      print("ddd" + t.toString());
      return new Container(
        child: SlideView(t),
        height: 180,
      );
    }, itemBuilder: (context, t) {
      print("ccccccccccccccccccccccccccccccccc");
      print(t);
      return new ArticleItem(t);
    }, onLoad: (int page) {
      print(page);
      if (page == 0) {
        p.getBanner();
      }
      p.getHomeArticlelist(page);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adapter.start();
  }

  @override
  Widget build(BuildContext context) {
    print("HomeListWidget_build");
    // TODO: implement build
    return _adapter.build(context);
  }

  @override
  void dispose() {
    _adapter.dispose();
    super.dispose();
  }

  void notify(Message msg) {
    print("HomeListWidget_notifyData");
    switch (msg.action) {
      case 0:
        print("getBanner" + msg.data.toString());
        setState(() {
          _adapter.headerData = msg.data;
        });
        break;
      case 1:
        Map<String, dynamic> map = msg.data;
        var _listData = map['datas'];
        setState(() {
          _adapter.addData = _listData;
        });
        break;
    }
  }
}
