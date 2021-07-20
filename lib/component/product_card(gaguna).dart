import 'package:flutter/material.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:lets_shop_admin/screens/edit_product.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;

  ProductCard({Key key, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          changeScreen(context, EditProduct(product: widget.product));
        },
        child: Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-2, -1),
                    blurRadius: 5),
              ]),
          child: Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(children: <Widget>[
                      Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Loading(),
                          )),
//              IMPLEMENTATION LOADING IMAGE TRANSPARENT WHEN PRODUCT IMAGE LOAD FROM DB
                      Center(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: widget.product.imageUrl,
                          fit: BoxFit.cover,
                          height: 140,
                          width: 120,
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${widget.product.name} \n',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextSpan(
                      text: 'by: ${widget.product.brand} \n\n',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    TextSpan(
                      text: widget.product.featured ? 'Featured Product\n' : '\n',
                      style: TextStyle(
                          fontSize: 18),
                    ),
                    TextSpan(
                      text: widget.product.sale ? 'ON SALE\n' : '\n',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.red),
                    ),
                    TextSpan(
                      text: '${formatCurrency.format(widget.product.price)} \t',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ], style: TextStyle(color: Colors.black)),
                ),
                Expanded(
                  child: IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: blue,
                      ),
                      onPressed: (){

                      }),
                ),
              ],
            ),
          ),
        )
    );
  }
}
