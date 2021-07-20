import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ConnectivityProvider extends ChangeNotifier{

  Connectivity _connectivity = new Connectivity();

  bool _isOnline;
  bool get isOnline => _isOnline;

  startMonitoring() async{
    await initConnectivity();
    //Stream check connection
    _connectivity.onConnectivityChanged.listen((result) async{
      if(result == ConnectionState.none){
        _isOnline = false;
        notifyListeners();
      }else{
        await _updateConnectionStatus().then((bool isConnected) {
          _isOnline = isConnected;
          notifyListeners();
        });
      }
    });
  }

  Future<void> initConnectivity() async{
    try{
      // Future check connection
      var status = await _connectivity.checkConnectivity();

      //None itu berarti tidak ada koneksi internet
      if(status == ConnectionState.none){
        _isOnline = false;
        notifyListeners();
      }else{
        _isOnline = true;
        notifyListeners();
      }
    } on PlatformException catch (e){
      print('PlatformExceptrion : $e');
    }
  }

  Future<bool> _updateConnectionStatus() async{
    bool isConnected;
    try{
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        isConnected = true;
      }
    } on SocketException catch(_){
      isConnected = false;
    }

    return isConnected;
  }
}