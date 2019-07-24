import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/bloc/base_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';

abstract class BaseListStatelessWidget<T, B extends BaseListBloc<T>>
    extends BaseStatelessWidget<LoadingBean<List<T>>, B> {
  static final String TAG = "BaseListStatelessWidget";

  Widget builderItem(BuildContext context, T item);


  bool enablePullUp() {
    return true;
  }

  @override
  bool isLoading(LoadingBean<List<T>> data) {
    return data != null ? data.isLoading : true;
  }

  @override
  int getItemCount(LoadingBean<List<T>> data) {
    if (data == null) {
      return 0;
    }
    return data.data == null ? 0 : data.data.length;
  }

  @override
  Widget buildItemBuilder(
      BuildContext context, LoadingBean<List<T>> data, int index) {
    T model = data.data[index];
    return builderItem(context, model);
  }
}
