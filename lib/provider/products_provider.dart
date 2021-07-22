import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:lets_shop_admin/service/brand.dart';
import 'package:lets_shop_admin/service/order.dart';
import 'package:lets_shop_admin/service/product.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lets_shop_admin/service/user.dart';

class ProductProvider with ChangeNotifier{
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();
  UserService _userService = UserService();
  OrderService _orderService = OrderService();
  List<ProductModel> products = [];
  List<String> selectedColors = [];

  int countBrand;
  int countProduct;
  int countUser;
  int countOrder;
  int countSold;

  ProductProvider.initialize(){
    loadProducts();
    getBrands();
    getSold();
    getUsers();
    getProducts();
    getOrders();
  }

  addColor(String color){
    selectedColors.add(color);
    print(selectedColors.length.toString());
    notifyListeners();
  }

  removeColor(String color){
    selectedColors.remove(color);
    print(selectedColors.length.toString());
    notifyListeners();
  }

  loadProducts() async{
    products = await _productService.getProducts();
    notifyListeners();
  }

  /*Future */reloadProducts() async{
    products = await _productService.getProducts();
    notifyListeners();
  }

  getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrand();
    print('data ${data.length}');
    countBrand = data.length;
    notifyListeners();
  }

  getProducts() async {
    List<DocumentSnapshot> data = await _productService.getDashboard_products();
    print('Product ${data.length}');
    countProduct = data.length;
    notifyListeners();
  }

  getUsers() async {
    List<DocumentSnapshot> data = await _userService.getUsers();
    print('Users ${data.length}');
    countUser = data.length;
    notifyListeners();
  }

  getOrders() async {
    List<DocumentSnapshot> data = await _orderService.getOrders();
    print('Order ${data.length}');
    countOrder = data.length;
    notifyListeners();
  }

  getSold() async {
    List<DocumentSnapshot> data = await _orderService.getSold();
    print('Sold ${data.length}');
    countSold = data.length;
    notifyListeners();
  }


  Future<bool> addProduct(String name, price, oldPrice, String desc, String color, File images,
      /*int qty, String category,*/ String brand, bool sale, bool featured) async{
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

        print('img URL : $imageUrl');
        print('oldPrice : $oldPrice');

        _productService.uploadProduct(
            name,
            price,
            oldPrice,
            desc,
            color,
            imageUrl,
            picture,
            brand,
            sale,
            featured
          );
        });
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateProduct(String productId, String name, price, oldPrice, String desc, String color, File images,
      /*int qty, String category,*/ String brand, bool sale, bool featured, {String oldImageUrl, String oldImageRef}) async{
    try{
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      if(images == null){
        _productService.updateProduct(
            productId,
            name,
            price,
            oldPrice,
            desc,
            color,
            oldImageUrl,
            oldImageRef,
            brand,
            sale,
            featured
        );
      }else{
        String _imageUrl;
        await storage.ref(oldImageRef).delete();
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

          _productService.updateProduct(
              productId,
              name,
              price,
              oldPrice,
              desc,
              color,
              _imageUrl,
              picture,
              brand,
              sale,
              featured
            );
          });
       }
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }


  Future<bool> deleteProduct({String productID, String imageRef}) async{
    try{
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      await storage.ref(imageRef).delete();
      _productService.deleteProduct(productId: productID);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

}