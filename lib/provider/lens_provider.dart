
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop_admin/models/lens.dart';
import 'package:lets_shop_admin/service/lens.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class LensProvider with ChangeNotifier{
  LensService _lensService = LensService();

  List<LensModel> lens = [];

  int countLens;

  LensProvider.initialize(){
    loadLens();
    getLens();
  }

  loadLens() async{
    lens = await _lensService.getLens();
    print('lens length ${lens.length}');
    notifyListeners();
  }

  reloadLens() async{
    lens = await _lensService.getLens();
    notifyListeners();
  }

  getLens() async {
    List<DocumentSnapshot> data = await _lensService.getDashboard_lens();
    print('lens ${data.length}');
    countLens = data.length;
    notifyListeners();
  }

  Future<bool> addLens(String name, price, oldPrice, String desc, String color,
      File images, String brand, bool sale,) async{
    String imageUrl;
    try{
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      final String picture =
          '${DateTime
          .now()
          .millisecondsSinceEpoch
          .toString()}.jpg';
      firebase_storage.UploadTask uploadTask =
      storage.ref().child(picture).putFile(images);

      firebase_storage.TaskSnapshot snapshot1 =
      await uploadTask.then((snapshot) => snapshot);

      uploadTask.then((snapshot) async {
        imageUrl = await snapshot1.ref.getDownloadURL();
        _lensService.createLens(
            name,
            brand,
            desc,
            color,
            oldPrice,
            price,
            sale,
            imageUrl,
            picture);
      });
      return true;
    }catch(e){
      print("THE ERROR addLens ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateLens(String lensId, String name, price, oldPrice, String desc, String color, File images,
      String brand, bool sale, {String oldImageUrl, String oldImageRef}) async{
    try{
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      if(images == null){
        _lensService.updateLens(
            lensId,
            name,
            brand,
            desc,
            color,
            oldPrice,
            price,
            sale,
            oldImageUrl,
            oldImageRef
        );
      }else{
        String _imageUrl;
        await storage.ref(oldImageRef).delete();
        print('oldimageRef : $oldImageRef');

        final String picture =
            '${DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()}.jpg';
        firebase_storage.UploadTask uploadTask =
        storage.ref().child(picture).putFile(images) ?? "";

        firebase_storage.TaskSnapshot snapshot1 =
        await uploadTask.then((snapshot) => snapshot);

        uploadTask.then((snapshot) async {
          _imageUrl = await snapshot1.ref.getDownloadURL();
          _lensService.updateLens(
              lensId,
              name,
              brand,
              desc,
              color,
              oldPrice,
              price,
              sale,
              _imageUrl,
              picture
          );
        });
      }
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteLens({String lensID, String imageRef}) async{
    try{
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      await storage.ref(imageRef).delete();
      _lensService.deleteLens(lensId: lensID);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }
}