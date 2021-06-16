import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  static const ID = 'id';
  static const NAME = 'name';
  static const PRICE = 'price';
  static const BRAND = 'brand';
  static const CATEGORY = 'category';
  static const DESCRIPTION = "description";
  static const COLOR = 'color';
  static const FEATURED = 'featured';
  static const IMAGES = 'images';
  static const IMAGESREF = 'imagesref';
  static const QUANTITY = 'quantity';
  static const SALE = 'sale';
  static const SIZES = 'sizes';

// Private Variabel
  String _id;
  String _brand;
  String _category;
  String _name;
  String _description;
  String _imageUrl;
  String _imageRef;
  int _price;
  int _quantity;
  List _color;
  List _sizes;
  bool _featured;
  bool _sale;

//Getter read only for private variabel
  String get id => _id;
  String get name => _name;
  String get brand => _brand;
  String get category => _category;
  String get description => _description;
  String get imageUrl => _imageUrl;
  String get imageRef => _imageRef;
  int get price => _price;
  int get quantity => _quantity;
  List get color => _color;
  List get sizes => _sizes;
  bool get featured => _featured;
  bool get sale => _sale;

//Contructure data from DB
  ProductModel.fromSnapshot(DocumentSnapshot snapshot){
    /*Map data = snapshot.data();*/
    _id = snapshot.data()[ID];
    _name = snapshot.data()[NAME];
    _brand = snapshot.data()[BRAND];
    _category = snapshot.data()[CATEGORY];
    _description = snapshot.data()[DESCRIPTION] ?? "";
    _imageUrl = snapshot.data()[IMAGES];
    _imageRef = snapshot.data()[IMAGESREF];
    _price = snapshot.data()[PRICE].floor();
    _quantity = snapshot.data()[QUANTITY];
    _color = snapshot.data()[COLOR];
    _sizes = snapshot.data()[SIZES];
    _featured = snapshot.data()[FEATURED];
    _sale = snapshot.data()[SALE];

  }
}