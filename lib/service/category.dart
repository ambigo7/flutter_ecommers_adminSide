import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createCategory(String name){
    //Generate Key for categoryID
    var id = Uuid();
    String categoryId = id.v1();

    _firestore.collection('categories').doc(categoryId).set({'category': name});
  }
}