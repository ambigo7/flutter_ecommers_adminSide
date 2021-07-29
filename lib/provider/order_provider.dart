import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop_admin/models/order.dart';
import 'package:lets_shop_admin/service/order.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class OrderProvider with ChangeNotifier{
  OrderService _orderService = OrderService();

  int countOrderIncomplete;
  int countOrderPending;
  int countSold;

  int totalPayment;

  OrderModel _orderModel;

  List<OrderModel> incompleteOrders = [];
  List<OrderModel> pendingOrders = [];
  List<OrderModel> validationSuccess = [];
  List<OrderModel> readyToPickUp = [];
  List<OrderModel> deliveryOrders = [];
  List<OrderModel> completedOrders = [];

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  OrderProvider.initialize(){
    getTotalPayment();
    getOrdersIncomplete();
    getIncompleteOrder();
    getPendingOrder();
    getValidationSuccessOrder();
    getReadyToPickUp();
    getDeliveryOrder();
    getCompletedOrder();
    getOrdersPending();
    getSold();
  }

  Future getTotalPayment() async{
    totalPayment = await _orderService.getTotalPayment();
    // print('revenue : $totalPayment');
    notifyListeners();
  }

  Future<void> reloadValidationSuccessOrder()async{
    validationSuccess = await _orderService.getListOrders(isEqualThis: 'Validation success');
    notifyListeners();
  }

  getIncompleteOrder() async{
    incompleteOrders = await _orderService.getListOrders(isEqualThis: 'Incomplete');
    print('Order Incomplete ${incompleteOrders.length}');
    notifyListeners();
  }

  getPendingOrder() async{
    pendingOrders = await _orderService.getListOrders(isEqualThis: 'Pending validation');
    print('Order pending ${pendingOrders.length}');
    notifyListeners();
  }

  getValidationSuccessOrder() async{
    validationSuccess = await _orderService.getListOrders(isEqualThis: 'Validation success');
    print('Order ValidationSuccess ${validationSuccess.length}');
    notifyListeners();
  }

  getReadyToPickUp() async{
    readyToPickUp = await _orderService.getListOrders(isEqualThis: 'Ready to pick up');
    print('Order ready to pick up ${readyToPickUp.length}');
    notifyListeners();
  }

  getDeliveryOrder() async{
    deliveryOrders = await _orderService.getListOrders(isEqualThis: 'Delivery');
    print('Order Delivery ${deliveryOrders.length}');
    notifyListeners();
  }

  getCompletedOrder() async{
    completedOrders = await _orderService.getListOrders(isEqualThis: 'Completed');
    print('Order Completed ${completedOrders.length}');
    notifyListeners();
  }

  getOrdersIncomplete() async {
    List<DocumentSnapshot> data = await _orderService.getCountOrders(isEqualThis: 'Incomplete');
    print('getOrdersIncomplete ${data.length}');
    countOrderIncomplete = data.length;
    notifyListeners();
  }

  getOrdersPending() async{
    List<DocumentSnapshot> data = await _orderService.getCountOrders(isEqualThis: 'Pending validation');
    print('getOrdersPending ${data.length}');
    countOrderPending = data.length;
    notifyListeners();
  }

  getSold() async {
    List<DocumentSnapshot> data = await _orderService.getCountOrders(isEqualThis: 'Completed');
    print('Sold ${data.length}');
    countSold = data.length;
    notifyListeners();
  }

  Future<bool> deleteImage({@required String imageRef}) async{
    try{
      await storage.ref(imageRef).delete();
      return true;
    }catch(e){
      print('ERROR: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateOrder({@required String orderId, @required String status})async{
    try{
      _orderService.updateOrder(Id: orderId, status: status);
      return true;
    }catch(e){
      print('ERROR: ${e.toString()}');
      return false;
    }
  }

  Future<bool> deleteOrder({@required String orderId,}) async{
    try{
      _orderService.deleteOrder(Id: orderId);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }
}