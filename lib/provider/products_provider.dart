import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  List<String> selectedColors = [];

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

}