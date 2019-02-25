import 'package:flutter/material.dart';

typedef BuildItemWidget<T> = Widget Function(BuildContext context, T t);
typedef BuildItem<T> = Widget Function(BuildContext context, T t);
typedef OnLoad = int Function(int page);

class BaseQuickAdapter<T> {
  ScrollController _controller;
  List<T> listData = new List<T>();
  int curPage = 0;
  int listTotalSize = 0;
  bool headAndEmptyEnable;
  bool enableLoadMore;
  Widget emptyWidget;
  List<HeaderAndFooterItemWidget> headers;
  List<HeaderAndFooterItemWidget> footers;
  static const HEADER_VIEW = 0x00000111;
  static const LOADING_VIEW = 0x00000222;
  static const FOOTER_VIEW = 0x00000333;
  static const EMPTY_VIEW = 0x00000555;
  static const INVALID_TYPE = -1;
  WidgetHolder holder = new WidgetHolder();
  BuildItemWidget<T> itemBuilder;
  OnLoad onLoad;

  BaseQuickAdapter(
      {this.curPage,
      this.enableLoadMore,
      this.headAndEmptyEnable,
      this.listTotalSize,
      @required this.itemBuilder,
      @required this.onLoad,
      this.headers = const <HeaderAndFooterItemWidget>[],
      this.footers = const <HeaderAndFooterItemWidget>[]})
      : assert(itemBuilder != null),
        assert(onLoad != null);

  void start() {
    print("start");
    _controller = new ScrollController();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (enableLoadMore && maxScroll == pixels) {
        loadMore();
      }
    });
    onRefresh();
  }

  /// 下拉刷新回调
  Future<Null> _pullToRefresh() async {
    onRefresh();
    return null;
  }

  /// 获取Item的类型
  int getItemViewType(int position) {
    if (position < headers.length) {
      return HEADER_VIEW;
    } else {
      int adjPosition = position - headers.length;
      int itemCount = listData.length;
      if (adjPosition < itemCount) {
        return INVALID_TYPE;
      } else {
        adjPosition = adjPosition - itemCount;
        int numFooters = footers.length;
        if (adjPosition < numFooters) {
          return FOOTER_VIEW;
        } else {
          return LOADING_VIEW;
        }
      }
    }
  }

  ///获取多样式布局类型样式
  int getDefItemViewType(int position) => -1;

  Widget getItemWidget(BuildContext context, int p) {
    int a = getItemCount();
    print("$a----$p");
    print("getItemWidget----$p");
    Widget loadView = holder.getWidget(p);
    if (loadView != null) {
      return loadView;
    }
    int viewType = getItemViewType(p);
    switch (viewType) {
      case LOADING_VIEW:
        Widget loadView = getLoadingView();
        return createBaseWidgetHolder(loadView, p);
      case HEADER_VIEW:
        print('HEADER_VIEW');
        return createBaseWidgetHolder(headers[p].build(context), p);
      case EMPTY_VIEW:
        return createBaseWidgetHolder(emptyWidget, p);
      case FOOTER_VIEW:
        print('FOOTER_VIEW');
        return createBaseWidgetHolder(footers[p].build(context), p);
      default:
        print('ITEM_View');
        return onCreateDefWidgetHolder(context, viewType, p);
    }
  }

  onCreateDefWidgetHolder(BuildContext context, int viewType, int p) {
    Widget widget = itemBuilder(context, listData[p]);
    return createBaseWidgetHolder(widget, p);
  }

  Widget createBaseWidgetHolder(Widget widget, int position) {
    holder.addWidget(widget, position);
    return widget;
  }

  Widget build(BuildContext context) {
    if (listData == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      print("listView");
      Widget listView = new ListView.builder(
        itemCount: getItemCount(),
        itemBuilder: (context, i) => getItemWidget(context, i),
        controller: _controller,
      );
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  int getItemCount() {
    return listData.length + headers.length + footers.length;
  }

  void setNewData(List<T> data) {
    if (listData.length > 0) {
      listData.clear();
    }
    listData.addAll(data);
  }

  void addData(List<T> data) {
    listData.addAll(data);
  }

  Widget getLoadingView() {
    return null;
  }

  ///加载更多
  void loadMore() {
    curPage++;
    onLoad(curPage);
  }

  ///刷新
  void onRefresh() {
    curPage = 0;
    onLoad(curPage);
  }

  loadMoreEnd(bool gone) {}

  loadMoreComplete() {}

  loadMoreFail() {}

  int getHeaderWidgetCount() => headers.length;

  int getFooterWidgetCount() => footers.length;

  void dispose() {
    _controller.dispose();
  }
}

///增加widget 缓冲
class WidgetHolder {
  Widget itemWidget;
  Map<int, Widget> widgetHolder;

  WidgetHolder() {
    if (this.widgetHolder == null) {
      this.widgetHolder = new Map();
    }
  }

  addWidget(Widget itemWidget, int position) {
    this.widgetHolder[position] = itemWidget;
  }

  Widget getWidget(int position) {
    Widget widget = this.widgetHolder[position];
    return widget;
  }
}

abstract class MultiItemEntity {
  int getItemType() => -1;
}

abstract class BaseMultiItemQuickAdapter<T extends MultiItemEntity>
    extends BaseQuickAdapter<T> {}

class HeaderAndFooterItemWidget<T> {
  BuildItem<T> itemBuilder;
  T t;

  HeaderAndFooterItemWidget({@required this.itemBuilder, this.t})
      : assert(itemBuilder != null);

  Widget build(BuildContext context) {
    return itemBuilder(context, t);
  }
}
