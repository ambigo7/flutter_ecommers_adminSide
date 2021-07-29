import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const MESSAGE = "message";
  static const SERVICE = "service";
  static const CHARGES = "charges";
  static const USER_ID = "userId";
  static const TOTAL_PRODUCT_PRICE = "totalProductPrice";
  static const TOTAL_LENS_PRICE = "totalLensPrice";
  static const TOTAL_CART_PRICE = "totalCartPrice";
  static const TOTAL_PAYMENT= "totalPayment";
  static const STATUS = "status";
  static const ORDER_TIME = "orderTime";
  static const PAYMENT_TIME = "paymentTime";
  static const SHIP_TIME = "shipTime";
  static const COMPLETED_TIME = "completedTime";
  static const IMAGE_REF = "imgRef";
  static const IMAGE_URL_PAYMENT = "imgUrlPayment";

  String _id;
  String _description;
  String _userId;
  String _status;
  String _message;
  String _service;
  String _imgRef;
  String _imgUrlPayment;
  int _orderTime;
  int _paymentTime;
  int _shipTime;
  int _completedTime;
  int _charges;
  int _totalProductPrice;
  int _totalLensPrice;
  int _totalCartPrice;
  int _totalPayment;

  int _revenue = 0;


//  getters
  String get id => _id;
  String get description => _description;
  String get userId => _userId;
  String get status => _status;
  String get message => _message;
  String get service => _service;
  String get imgRef => _imgRef;
  String get imgUrlPayment => _imgUrlPayment;
  int get charges => _charges;
  int get totalProductPrice => _totalProductPrice;
  int get totalLensPrice => _totalLensPrice;
  int get totalCartPrice => _totalCartPrice;
  int get totalPayment => _totalPayment;
  int get orderTime => _orderTime;
  int get paymentTime => _paymentTime;
  int get shipTime => _shipTime;
  int get completedTime => _completedTime;
  int get revenue => _revenue;

  // public variable
  List<CartItemModel> cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION];
    _imgRef = snapshot.data()[IMAGE_REF] ?? "";
    _imgUrlPayment = snapshot.data()[IMAGE_URL_PAYMENT] ?? "";
    _totalProductPrice = snapshot.data()[TOTAL_PRODUCT_PRICE];
    _totalLensPrice = snapshot.data()[TOTAL_LENS_PRICE];
    _totalCartPrice = snapshot.data()[TOTAL_CART_PRICE];
    _totalPayment = snapshot.data()[TOTAL_PAYMENT];
    _status = snapshot.data()[STATUS];
    _message = snapshot.data()[MESSAGE] ?? "";
    _service = snapshot.data()[SERVICE];
    _charges = snapshot.data()[CHARGES];
    _userId = snapshot.data()[USER_ID];
    _orderTime = snapshot.data()[ORDER_TIME];
    _paymentTime = snapshot.data()[PAYMENT_TIME];
    _shipTime = snapshot.data()[SHIP_TIME];
    _completedTime = snapshot.data()[COMPLETED_TIME];
    cart = _convertCartItems(snapshot.data()[CART] ?? []);
  }

  //Ini buat jaga2 kalo dibutuhin
/*
  OrderModel.fromFirebase(Map data){
    _idMap = data[ID];
    _descriptionMap = data[DESCRIPTION];
    _totalMap = data[TOTAL];
    _statusMap = data[STATUS];
    _messageMap = data[MESSAGE] ?? "";
    _userIdMap = data[USER_ID];
    _createdAtMap = data[CREATED_AT];
    cartMap = _convertCartItems(data[CART] ?? []);
  }
*/

  //Firebase tdk mengerti tipe data List makanya harus diconvert ke Map
  List<CartItemModel> _convertCartItems(List cart){
    List<CartItemModel> convertedCart = [];
    for(Map cartItem in cart){
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }

  //Total Price for cart item
  int getTotalRevenue({totalPayment}){
/*    if(cart == null){
      return 0;
    }*/
    for(DocumentSnapshot total in totalPayment){
      _revenue += total["priceLens"];
    }

    int total = _revenue;
    return total;
  }
}