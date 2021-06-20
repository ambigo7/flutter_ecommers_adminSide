import 'package:flutter/material.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:lets_shop_admin/service/product.dart';

class ProductProvider with ChangeNotifier{

  ProductService _productService = ProductService();
  List<ProductModel> products = [];
  List<ProductModel> rldProducts = [];
  List<String> selectedColors = [];

  ProductProvider.initialize(){
    loadProducts();
    reloadProducts();
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

  reloadProducts() async{
    rldProducts = await _productService.getProducts();
    notifyListeners();
  }

  Future<bool> deleteProduct({String productID}) async{
    try{
      await _productService.deleteProduct(productId: productID);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

}