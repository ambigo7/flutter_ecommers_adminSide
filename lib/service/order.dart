import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lets_shop_admin/models/order.dart';
import 'package:uuid/uuid.dart';

class OrderService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'orders';


  Future<List<OrderModel>> getListOrders({@required String isEqualThis}) async =>
      _firestore
          .collection(ref)
          .where('status', isEqualTo: isEqualThis)
          .get().then((result) {
        List<OrderModel> orders = [];
        DocumentSnapshot order;
        for (order in result.docs) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });


  // Get data Orders
  Future<List<DocumentSnapshot>> getCountOrders({@required String isEqualThis}) =>
      _firestore
          .collection(ref)
          .where('status', isEqualTo: isEqualThis)
          .get()
          .then((snaps) {
        return snaps.docs;
      });

  Future getTotalPayment() async{
    _firestore
    .collection(ref)
        .where('status', isEqualTo: "Completed")
        .get()
        .then((value) {
          value.docs.forEach((result) {
            print('revenue : ${result.data()['totalPayment']}');
          });
      /*DocumentSnapshot total;
      for (total in value.docs) {
        print('revenue : ${total.data()['totalPayment']}');
      }*/
    });
  }

  void updateOrder({String Id, String status}){
      _firestore
          .collection(ref)
          .doc(Id)
          .update({
        "status": status,
        "imgUrlPayment": FieldValue.delete(),
        "imgRef": FieldValue.delete()
      });
  }

  void deleteOrder({String Id}){
    _firestore
        .collection(ref)
        .doc(Id)
        .delete()
        .then((value) => print('Order has been deleted'));
  }
}