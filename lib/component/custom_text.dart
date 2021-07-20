import 'package:flutter/material.dart';
import 'package:lets_shop_admin/commons/color.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final TextAlign align;
  final FontWeight weight;

//CUNSTRUKTOR REQUIRED
  CustomText({@required this.text, this.size, this.color, this.align, this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          color: color ?? black,
          fontWeight: weight ?? FontWeight.normal,
          fontSize: size ?? 16),
      textAlign: align ?? TextAlign.start,
    );
  }
}
