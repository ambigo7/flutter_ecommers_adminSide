

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:uuid/uuid.dart';

class ProductService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = 'products';
  CollectionReference _products = FirebaseFirestore.instance.collection(
      'products');

  //create product data to cloud firestore
  void uploadProduct(name, price, desc, sizes, color, images, imgRef, qty, category, brand, sale, featured){
    //Generate Key for brandID
    var id = Uuid();
    String productId = id.v1();
    _firestore.collection(collection).doc(productId).set(
        {
          "id": productId,
          "name": name,
          "price": double.parse(price),
          "description": desc,
          "sizes": color,
          "color": color,
          "images": images,
          "imagesref": imgRef,
          "quantity": int.parse(qty),
          "category": category,
          "brand": brand,
          "sale": sale,
          "featured": featured
        }
    );
  }

  //create product data to cloud firestore
  void updateProduct(productId, name, price, desc, sizes, color, images, imgRef, qty, category, brand, sale, featured){

    _firestore.collection(collection).doc(productId).update(
      {
        "id": productId,
        "name": name,
        "price": double.parse(price),
        "description": desc,
        "sizes": color,
        "color": color,
        "images": images,
        "imagesref": imgRef,
        "quantity": int.parse(qty),
        "category": category,
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
}