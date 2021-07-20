import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/component/custom_text.dart';
import 'package:lets_shop_admin/component/product_card(gaguna).dart';
import 'package:lets_shop_admin/provider/app_provider.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../screens/edit_product.dart';

class ProductList extends StatefulWidget {

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _key = GlobalKey<ScaffoldState>();
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: blue),
        backgroundColor: white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pop(context);
        }),
        title: CustomText(text: "List of Products", size: 20, color: blue, weight: FontWeight.bold,),
        elevation: 0.0,
        centerTitle: true,
      ),
      // ? is a null awareness(boleh kalo ga punya nilai)
      body: productProvider.products.length < 1? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.search, color: grey, size: 30,),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText(text: "No products Found", color: grey, weight: FontWeight.w300, size: 22,),
            ],
          )
        ],
      ) : ListView.builder(
          itemCount: productProvider.products.length,
          itemBuilder: (context, index){
            return GestureDetector(
                onTap: () {
                  changeScreen(context, EditProduct(product: productProvider.products[index]));
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
                                  image: productProvider.products[index].imageUrl,
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
                              text: '${productProvider.products[index].name} \n',
                              style: TextStyle(fontSize: 20),
                            ),
                            TextSpan(
                              text: 'by: ${productProvider.products[index].brand} \n',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            TextSpan(
                              text: productProvider.products[index].featured ? 'Featured Product\n' : '\n',
                              style: TextStyle(
                                  fontSize: 18),
                            ),
                            TextSpan(
                              text: productProvider.products[index].sale ? 'ON SALE\n' : '\n',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                            ),
                            TextSpan(
                              text: productProvider.products[index].oldPrice != 0
                                  ? '${formatCurrency.format(productProvider.products[index].oldPrice)}\n' : '\n',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.red),
                            ),
                            TextSpan(
                              text: '${formatCurrency.format(productProvider.products[index].price)} \t',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ], style: TextStyle(color: Colors.black)),
                        ),
                        Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: redAccent,
                              ),
                              onPressed: () async{
                                appProvider.changeIsLoading();
                                bool success =
                                    await productProvider.deleteProduct(
                                        productID: productProvider.products[index].id,
                                        imageRef:productProvider.products[index].imageRef );
                                if(success){
                                  productProvider.loadProducts();
                                  print("Product deleted");
                                  _key.currentState.showSnackBar(SnackBar(
                                      backgroundColor: white,
                                      content: Text("Product has been deleted",
                                          style: TextStyle(
                                              color: blue))));
                                  appProvider.changeIsLoading();

                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                )
            );
          }),
    );
  }
}