import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  final String title;
  final String url;

  PhotoViewPage(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: YZConstant.normalTextWhite,
          ),
        ),
        body: Container(
          color: Colors.black,
          child: PhotoView(
            imageProvider: NetworkImage(url),
            loadingChild: Container(
              child: Stack(
                children: <Widget>[
                  Center(
                      child: ImageUtil.getImage(
                          'image/ic_default_head.png', 180.0, 180.0)),
                  Center(
                    child: SpinKitCircle(color: Colors.white30, size: 25.0),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
