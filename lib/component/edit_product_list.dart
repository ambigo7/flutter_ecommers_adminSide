import 'package:flutter/material.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/component/custom_text.dart';
import 'package:lets_shop_admin/component/product_card.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product.dart';

class EditProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: redAccent),
        backgroundColor: white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pop(context);
        }),
        title: CustomText(text: "List of Products", size: 20, color: redAccent, weigth: FontWeight.bold,),
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
              CustomText(text: "No products Found", color: grey, weigth: FontWeight.w300, size: 22,),
            ],
          )
        ],
      ) : ListView.builder(
          itemCount: productProvider.products.length,
          itemBuilder: (context, index){
            return GestureDetector(
                onTap: ()async{
                  changeScreen(context, EditProduct(product: productProvider.products[index]));
                },
                child: ProductCard(product:  productProvider.products[index]));
          }),
    );
  }
}