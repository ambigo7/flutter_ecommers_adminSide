import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'categories';

  void createCategory(String name){
    //Generate Key for categoryID
    var id = Uuid();
    String categoryId = id.v1();

    _firestore.collection(ref).doc(categoryId).set({'category': name});
  }

  // Get data catergories
  Future<List<DocumentSnapshot>> getCategories(){
    return _firestore.collection(ref).get().then((snaps){
      return snaps.docs;
    });
  }
}