import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop_admin/provider/app_provider.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';
import 'package:lets_shop_admin/screens/admin.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ProductProvider.initialize()),
        ChangeNotifierProvider.value(value: AppProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.deepOrangeAccent[700]),
        debugShowCheckedModeBanner: false,
        home: Admin(),
      )
    )
  );
}
