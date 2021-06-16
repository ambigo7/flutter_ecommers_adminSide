import 'package:flutter/material.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:lets_shop_admin/service/product.dart';

class ProductProvider with ChangeNotifier{
  ProductService _productService = ProductService();
  List<ProductModel> products = [];
  List<String> selectedColors = [];

  ProductProvider.initialize(){
    loadProducts();
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

}