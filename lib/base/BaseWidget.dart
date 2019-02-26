import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanAndroid/base/Presenter.dart';

@optionalTypeArgs
abstract class BaseWidget extends StatefulWidget {
  const BaseWidget({Key key}) : super(key: key);
}

abstract class BaseState<W extends BaseWidget> extends State<W> {
  ViewConfig config;
  UiWidget uiWidget;

  BaseState({@required this.uiWidget, this.config}) {
    if (uiWidget != null) {
      uiWidget.bind(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("notifyStatebuild");
    return uiWidget.build(context, config);
  }

  ///与 present 交互
  ///
  ///   state.notifyData(Message(action: 0, data: result));
  void notifyData(Message msg) {
    if (uiWidget != null) {
      uiWidget.notifyData(msg);
    }
  }

  void notifyState(VoidCallback fn) {
    print("notifyState");
    print(this);
    this.setState(fn);
  }
}

class UiWidget<P extends Presenter> {
  P presenter;
  BaseState state;

  UiWidget({this.presenter});

  void initState() {}

  void dispose() {}

  void notifyData(Message msg) {
    print('UiWidget');
  }

  void setState(VoidCallback fn) {
    state.notifyState(fn);
  }

  Widget build(BuildContext context, ViewConfig config) => null;

  void bind(BaseState baseState) {
    this.state = baseState;
    if (this.presenter != null) this.presenter.bind(state);
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
