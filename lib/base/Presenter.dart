import 'dart:ui';

import 'package:wanAndroid/base/BaseWidget.dart';

class Presenter {
  BaseState state;

  bind(BaseState state) {
    this.state = state;
  }

  void setState(VoidCallback fn) {
    state.notifyState(fn);
  }
}
