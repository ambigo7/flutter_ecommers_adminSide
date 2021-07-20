import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/provider/app_provider.dart';
import 'package:lets_shop_admin/provider/connectivity_provider.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';
import 'package:lets_shop_admin/screens/admin.dart';
import 'package:lets_shop_admin/screens/nointernet.dart';
import 'package:provider/provider.dart';

import 'commons/loading.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
          child: CheckConnection(),
        ),
        ChangeNotifierProvider.value(value: ProductProvider.initialize()),
        ChangeNotifierProvider.value(value: AppProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: blue),
        debugShowCheckedModeBanner: false,
        home: CheckConnection(),
      )
    )
  );
}

class CheckConnection extends StatefulWidget {
  @override
  _CheckConnectionState createState() => _CheckConnectionState();
}

class _CheckConnectionState extends State<CheckConnection> {

  @override
  void initState(){
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return PageUI();
  }

  Widget PageUI(){
    return Consumer<ConnectivityProvider>(
        builder: (context, model, child){
          if(model.isOnline != null){
            return model.isOnline
                ? Admin()
                : NoInternet();
          }
          return Center(child: Loading());
        }
    );
  }
}
