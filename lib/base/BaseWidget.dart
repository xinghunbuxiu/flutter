import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanAndroid/base/Presenter.dart';

mixin IMessage {
  void notify(Message message);
}

@optionalTypeArgs
abstract class BaseWidget extends StatefulWidget {
  const BaseWidget({Key key}) : super(key: key);
}

abstract class BaseState<W extends BaseWidget, P extends Presenter>
    extends State<W> with IMessage {
  ViewConfig config;
  P p;

  BaseState({this.p, this.config}) {
    if (p != null) {
      p.bind(this);
    }
  }

  Widget build(BuildContext context);

  @override
  void notify(Message message) {
    // TODO: implement notify
  }
}

class ViewConfig {
  ViewConfig(
      {this.hasTitle = true,
      this.hasBottom = false,
      this.titleColor = const Color(0xffffffff),
      this.titleSize = 12,
      this.navigatorKey,
      this.background = const Color(0xff0091ea)});

  Color accentColor;
  Color primaryColor;
  GlobalKey<NavigatorState> navigatorKey;

  double titleSize;

  bool hasTitle;

  Color titleColor;

  Color background;
  bool hasBottom;
}

class Message {
  int action;
  var data;

  Message({this.action, this.data});
}
