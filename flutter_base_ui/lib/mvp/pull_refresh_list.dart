import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_ui/mvp/base_presenter.dart';
import 'package:flutter_base_ui/mvp/base_state.dart';
import 'package:flutter_base_ui/mvp/i_base_pull_list_view.dart';
import 'package:flutter_common_util/flutter_common_util.dart';

abstract class PullRefreshListState<R extends StatefulWidget, T,
        P extends BasePresenter<V>, V extends IBasePullListView>
    extends BaseState<R, P, V> implements IBasePullListView<T> {
  List<T> _list = [];

  int page = 1;

  final ScrollController _scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool isLoading = false;
  bool isNoMore = false;

  Future<Null> onRefresh();

  Widget getItemRow(T item);

  Widget getHeader() {
    return null;
  }

  bool isSupportLoadMore() {
    return true;
  }

  void deleteItem(T item) {
    if (_list.contains(item)) {
      _list.remove(item);
    }
  }

  void addItem(T item) {
    _list.add(item);
  }

  bool isFirstLoading() {
    return true;
  }

  getMoreData() {
    return null;
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      var position = _scrollController.position;
      // 小于50px时，触发上拉加载；
      if (position.maxScrollExtent - position.pixels < 50 &&
          !isNoMore &&
          isSupportLoadMore()) {
        _loadMore();
      }
    });

    if (isFirstLoading()) {
      showRefreshLoading();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: ListView.builder(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _getListItemCount(),
          itemBuilder: (context, index) {
            return _getRow(context, index);
          },
        ),
        onRefresh: onRefresh);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  clearList() {
    _list.clear();
  }

  @override
  void setList(List<T> list, bool isFromMore) {
    int size = 0;
    if (list != null && list.length > 0) {
      size = list.length;
      //  Config.dart static const int PAGE_SIZE = 20;
      if (size < 20) {
        isNoMore = true;
      } else {
        isNoMore = false;
      }

      if (!isFromMore) {
        _list.clear();
      } else {
        isLoading = false;
      }
      _list.addAll(list);
    }
    setState(() {});
  }

  void showRefreshLoading() async {
    await Future.delayed(const Duration(seconds: 0), () {
      _refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }

  void _loadMore() async {
    if (!isLoading) {
      isLoading = true;
      setState(() {});

      getMoreData();
    }
  }

  Widget _getRow(BuildContext context, int index) {
    if (getHeader() != null && index == 0) {
      return getHeader();
    }
    if (_list.length == 0) {
      return _getEmptyWidget();
    }
    if (index < (getHeader() != null ? _list.length + 1 : _list.length)) {
      if (getHeader() != null) {
        index -= 1;
      }
      return getItemRow(_list[index]);
    }
    return _getMoreWidget();
  }

  Widget _getEmptyWidget() {
    return Container(
      width: ScreenUtil.getScreenWidth(context),
      height: ScreenUtil.getScreenHeight(context) - 100,
      child: Center(
        child: FlatButton(
            onPressed: () {
              showRefreshLoading();
            },
            child: Text("数据暂时为空")),
      ),
    );
  }

  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            isNoMore
                ? Text("")
                : SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                        strokeWidth: 4.0,
//                  backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation(Colors.black)),
                  ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: Text(
                isNoMore ? "没有更多数据" : "加载中...",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getListItemCount() {
    int count = _list.length;
    if (count == 0) {
      count += 1;
    }
    if (getHeader() != null) {
      count += 1;
    }
    if (isLoading) {
      count += 1;
    }
    if (isNoMore) {
      count += 1;
    }
    return count;
  }
}
