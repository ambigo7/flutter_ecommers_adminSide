import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class BrandService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'brands';

  void createBrand(String name){
    //Generate Key for brandID
    var id = Uuid();
    String brandId = id.v1();

    _firestore.collection(ref).doc(brandId).set({'brand': name});
  }

  Future<List<DocumentSnapshot>> getBrand(){
    return _firestore.collection(ref).get().then((snaps){
      return snaps.docs;
    });
/*    Stream<QuerySnapshot> snapshots =  _firestore.collection(ref).snapshots();
    List brands;
    snapshots.forEach((snap) {
      brands = snap.docs[];
      brands.insert(0, snap.docs);
    });*/
  }
}