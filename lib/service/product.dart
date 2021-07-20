

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:uuid/uuid.dart';

class ProductService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = 'products';
  CollectionReference _products = FirebaseFirestore.instance.collection(
      'products');

  //create product data to cloud firestore
  void uploadProduct(name, price, oldPrice, desc, color, images, imgRef, brand, sale, featured){
    //Generate Key for brandID
    var id = Uuid();
    String productId = id.v1();
    _firestore.collection(collection).doc(productId).set(
        {
          "id": productId,
          "name": name,
          "price": double.parse(price),
          "oldPrice": double.tryParse(oldPrice) ?? 0,
          "description": desc,
          "color": color,
          "images": images,
          "imagesref": imgRef,
          "brand": brand,
          "sale": sale,
          "featured": featured
        }
    );
  }

  //create productv data to cloud firestore
  void updateProduct(productId, name, price, oldPrice, desc, color, images, imgRef, brand, sale, featured){

    _firestore.collection(collection).doc(productId).update(
      {
        "id": productId,
        "name": name,
        "price": double.parse(price),
        "oldPrice": double.tryParse(oldPrice) ?? 0,
        "description": desc,
        "color": color,
        "images": images,
        "imagesref": imgRef,
        "brand": brand,
        "sale": sale,
        "featured": featured
      }
    );
  }

  // Get data Products For dashboard
  Future<List<DocumentSnapshot>> getDashboard_products() =>
      _firestore.collection(collection).get().then((snaps) {
        return snaps.docs;
      });

  // Get data Products
  Future<List<ProductModel>> getProducts() async =>
      _products
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  void deleteProduct({String productId}) async {


    _products
        .doc(productId)
        .delete()
        .then((value) => print('Product has been deleted'));
  }

}