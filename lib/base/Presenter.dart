import 'package:wanAndroid/base/BaseWidget.dart';

class Presenter {
  BaseState state;

  bind(BaseState state) {
    this.state = state;
  }
}
