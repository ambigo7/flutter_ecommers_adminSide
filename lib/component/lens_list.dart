import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/provider/app_provider.dart';
import 'package:lets_shop_admin/provider/lens_provider.dart';
import 'package:lets_shop_admin/screens/admin.dart';
import 'package:lets_shop_admin/screens/edit_lens.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'custom_text.dart';

class LensList extends StatefulWidget {
  @override
  _LensListState createState() => _LensListState();
}

class _LensListState extends State<LensList> {
  final _key = GlobalKey<ScaffoldState>();
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');


  @override
  Widget build(BuildContext context) {
    final lensProvider = Provider.of<LensProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: blue),
        backgroundColor: white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          changeScreen(context, Admin(page: 'manage',));
        }),
        title: CustomText(text: "List of Eyeglass", size: 20, color: blue, weight: FontWeight.bold,),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: lensProvider.lens.length < 1 ? Column(
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
              CustomText(text: "No Eyeglass Found", color: grey, weight: FontWeight.w300, size: 22,),
            ],
          )
        ],
      ) : appProvider.isLoading ? Loading()
          : ListView.builder(
          itemCount: lensProvider.lens.length,
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                changeScreen(context, EditLens(lens: lensProvider.lens[index]));
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
                                image: lensProvider.lens[index].imageUrl,
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
                            text: '${lensProvider.lens[index].name} \n',
                            style: TextStyle(fontSize: 20),
                          ),
                          TextSpan(
                            text: 'by: ${lensProvider.lens[index].brand} \n\n',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          TextSpan(
                            text: lensProvider.lens[index].sale ? 'ON SALE\n' : '\n',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                          TextSpan(
                            text: lensProvider.lens[index].oldPrice != 0
                                ? '${formatCurrency.format(lensProvider.lens[index].oldPrice)}\n' : '\n',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.red),
                          ),
                          TextSpan(
                            text: '${formatCurrency.format(lensProvider.lens[index].price)} \t',
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
                              await lensProvider.deleteLens(
                                  lensID: lensProvider.lens[index].id,
                                  imageRef:lensProvider.lens[index].imageRef );
                              if(success){
                                lensProvider.reloadLens();
                                print("Lens deleted");
                                _key.currentState.showSnackBar(SnackBar(
                                    backgroundColor: white,
                                    content: Text("Lens has been deleted",
                                        style: TextStyle(
                                            color: blue))));
                                appProvider.changeIsLoading();

                              }else{
                                print("Product deleted");
                                _key.currentState.showSnackBar(SnackBar(
                                    backgroundColor: white,
                                    content: Text("Lens failed to delete",
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
          })
    );
  }
}
