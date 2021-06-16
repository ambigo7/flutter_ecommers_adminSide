import 'package:flutter/material.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weigth;

//CUNSTRUKTOR REQUIRED
  CustomText({@required this.text, this.size, this.color, this.weigth});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color ?? black,
            fontWeight: weigth ?? FontWeight.normal,
            fontSize: size ?? 16));
  }
}
