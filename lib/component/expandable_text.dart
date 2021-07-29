import 'package:flutter/material.dart';
import 'package:lets_shop_admin/commons/color.dart';

class ExpandableText extends StatefulWidget {
  // ExpandableText(this.text, this.align);
  final String text;
  final TextAlign align;
  final double size;
  final Color color;
  final Color colorButton;

  ExpandableText({@required this.text, this.align, this.size, this.color, this.colorButton});

  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          child: new ConstrainedBox(
              constraints: widget.isExpanded
                  ? new BoxConstraints()
                  : new BoxConstraints(maxHeight: 50.0),
              child: new Text(
                widget.text,
                softWrap: true,
                overflow: TextOverflow.fade,
                textAlign: widget.align ?? TextAlign.start,
                style: TextStyle(
                    fontSize: widget.size ?? 16,
                    color: widget.color ?? black
                ),
              ))),
      widget.isExpanded
          ? new ConstrainedBox(constraints: new BoxConstraints())
          : new FlatButton(
          child: Text('Read More', style: TextStyle(color: widget.colorButton ?? black, fontSize:  widget.size ?? 16)),
          onPressed: () => setState(() => widget.isExpanded = true))
    ]);
  }
}