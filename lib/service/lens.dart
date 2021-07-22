import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop_admin/models/lens.dart';
import 'package:uuid/uuid.dart';

class LensService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'lens';

  void createLens(name, brand, desc, color, oldPrice, price, sale, imgUrl, imgRef ){
    //Generate Key for lensID
    var id = Uuid();
    String lensId = id.v1();
    _firestore.collection(ref).doc(lensId).set({
      "id": lensId,
      "name": name,
      "brand": brand,
      "description": desc,
      "sale": sale,
      "color": color,
      "price": double.parse(price),
      "oldPrice": double.tryParse(oldPrice) ?? 0,
      "imageUrl": imgUrl,
      "imageref": imgRef
    });
  }

  //create productv data to cloud firestore
  void updateLens(lensId, name, brand, desc, color, oldPrice, price, sale, imgUrl, imgRef){

    _firestore.collection(ref).doc(lensId).update(
        {
          "id": lensId,
          "name": name,
          "brand": brand,
          "description": desc,
          "sale": sale,
          "color": color,
          "price": double.parse(price),
          "oldPrice": double.tryParse(oldPrice) ?? 0,
          "imageUrl": imgUrl,
          "imageref": imgRef
        }
    );
  }

  // Get data Products For dashboard
  Future<List<DocumentSnapshot>> getDashboard_lens() =>
      _firestore
          .collection(ref).get().then((snaps) {
        return snaps.docs;
      });

  // Get data Products
  Future<List<LensModel>> getLens() async =>
      _firestore
          .collection(ref)
          .get()
          .then((result) {
        List<LensModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(LensModel.fromSnapshot(product));
        }
        return products;
      });

  void deleteLens({String lensId}) async {
    _firestore
        .collection(ref)
        .doc(lensId)
        .delete()
        .then((value) => print('Lens has been deleted'));
  }

}