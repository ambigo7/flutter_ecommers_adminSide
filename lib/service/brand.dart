import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'brands';

  void createBrand(String name){
    //Generate Key for brandID
    var id = Uuid();
    String brandId = id.v1();

    _firestore.collection(ref).doc(brandId).set({'brand': name});
  }

// Get data brands
  Future<List<DocumentSnapshot>> getBrand() =>
      _firestore.collection(ref).get().then((snaps){
        return snaps.docs;
      });

// Get data suggestion for auto complete search
  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('brand', isEqualTo: suggestion).get().then((snap){
        return snap.docs;
      });
}