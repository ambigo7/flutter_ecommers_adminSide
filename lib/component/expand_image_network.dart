import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lets_shop_admin/commons/color.dart';

import 'custom_text.dart';

class ExpandImageNetwork extends StatelessWidget {

  ///sumber fotonya network, isi network
  final String imageUrl;

  ///isi title kalo App bar true
  final String title;
  ///isi colorTitle kalo App bar true
  final Color colorTitle;
  ///isi sizeTitle kalo App bar true
  final double sizeTitle;

  ///kalo mau pas slideOut gambarnya keluar pake true
  final bool enableSlideOutPage;

  ///kalo mau pake appbar pake true
  bool appBar = false;

  // ignore: non_constant_identifier_names
  ExpandImageNetwork({this.imageUrl ,this.title, this.colorTitle, this.sizeTitle, this.appBar,
    this.enableSlideOutPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar != true
          ? null : AppBar(
        elevation: 0.1,
        backgroundColor: white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel_outlined, color: grey, size: 30,),
            onPressed: Navigator.of(context).pop,
          ),
        ],
        title: CustomText(
          text: title ?? 'Photo',
          size: sizeTitle ?? 16,
          weight: FontWeight.bold,
          color: colorTitle ?? black,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          // child: Hero(
          // tag: heroTag,
          child: ExtendedImageSlidePage(
              slideAxis: SlideAxis.both,
              slideType: SlideType.onlyImage,
              child: ExtendedImage.network(
                  imageUrl,
                  enableSlideOutPage: true,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) => GestureConfig(
                    minScale: 1.0,
                    animationMinScale: 0.8,
                    maxScale: 3.0,
                    animationMaxScale: 3.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: false,
                  ),
                  fit: BoxFit.scaleDown,
                )
          ),
        ),
      ),
    );
  }
}