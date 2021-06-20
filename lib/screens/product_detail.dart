import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//PACKAGE TYPE SUGGESTION
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

//PACKAGE IMAGE PICKER
import 'package:image_picker/image_picker.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/component/product_list.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';

import 'package:lets_shop_admin/service/category.dart';
import 'package:lets_shop_admin/service/brand.dart';
import 'package:lets_shop_admin/service/product.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'admin.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel product;

  const ProductDetail({Key key, this.product}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productQtyController = TextEditingController();
  final priceController = TextEditingController();
  TextEditingController productDescController = TextEditingController();

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
  <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<String> selectedSizes = <String>[];
  List<String> colors = <String>[];
  bool onSale = false;
  bool featured = false;


  File _image1;
  final picker = ImagePicker();

  bool isLoading = false;

  String _currentCategory = "";
  String _currentBrand = "";

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color redAccent = Colors.deepOrangeAccent[700];

  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  //GET IMAGE
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File tmpImg = await File(pickedFile.path);
    /*File tmpImg = File(pickedFile.path);*/
    /*tmpImg = await tmpImg.copy(tmpImg.path);*/

    setState(() => _image1 = tmpImg);
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i].data()['category']),
                value: categories[i].data()['category']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(brands[i].data()['brand']),
                value: brands[i].data()['brand']));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.1,
        title: Padding(
          padding: const EdgeInsets.only(left:80),
          child: Text(
            'Update Product',
            style: TextStyle(color: redAccent),
          ),
        ),
        //background nya masih white
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: redAccent,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: isLoading ? Center(child: CircularProgressIndicator())
            : ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 120,
                      child: OutlineButton(
                        borderSide:
                        BorderSide(color: grey.withOpacity(0.3), width: 2.5),
                        onPressed: () {
                          getImage();
                        },
                        child: _displayImage1(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),

            Center(child: Text('Available Colors')),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (productProvider.selectedColors.contains('red')) {
                        productProvider.removeColor('red');
                      } else {
                        productProvider.addColor('red');
                      }
                      setState(() {
                        colors = productProvider.selectedColors;
                      });
                    },
                    child: Container(width: 24, height: 24, decoration: BoxDecoration(
                        color: productProvider.selectedColors.contains('red') ? Colors.blue : grey,
                        borderRadius: BorderRadius.circular(15)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (productProvider.selectedColors.contains('yellow')) {
                        productProvider.removeColor('yellow');
                      } else {
                        productProvider.addColor('yellow');
                      }
                      setState(() {
                        colors = productProvider.selectedColors;
                      });
                    },
                    child: Container(width: 24, height: 24, decoration: BoxDecoration(
                        color: productProvider.selectedColors.contains('yellow') ? Colors.red : grey,
                        borderRadius: BorderRadius.circular(15)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (productProvider.selectedColors.contains('blue')) {
                        productProvider.removeColor('blue');
                      } else {
                        productProvider.addColor('blue');
                      }
                      setState(() {
                        colors = productProvider.selectedColors;
                      });
                    },
                    child: Container(width: 24, height: 24, decoration: BoxDecoration(
                        color: productProvider.selectedColors.contains('blue') ? Colors.red : grey,
                        borderRadius: BorderRadius.circular(15)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (productProvider.selectedColors.contains('green')) {
                        productProvider.removeColor('green');
                      } else {
                        productProvider.addColor('green');
                      }
                      setState(() {
                        colors = productProvider.selectedColors;
                      });
                    },
                    child: Container(width: 24, height: 24, decoration: BoxDecoration(
                        color: productProvider.selectedColors.contains('green') ? Colors.red : grey,
                        borderRadius: BorderRadius.circular(15)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (productProvider.selectedColors.contains('white')) {
                        productProvider.removeColor('white');
                      } else {
                        productProvider.addColor('white');
                      }
                      setState(() {
                        colors = productProvider.selectedColors;
                      });
                    },
                    child: Container(width: 24, height: 24, decoration: BoxDecoration(
                        color: productProvider.selectedColors.contains('white') ? Colors.red : grey,
                        borderRadius: BorderRadius.circular(15)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundColor: white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (productProvider.selectedColors.contains('black')) {
                        productProvider.removeColor('black');
                      } else {
                        productProvider.addColor('black');
                      }
                      setState(() {
                        colors = productProvider.selectedColors;
                      });
                    },
                    child: Container(width: 24, height: 24, decoration: BoxDecoration(
                        color: productProvider.selectedColors.contains('black') ? Colors.red : grey,
                        borderRadius: BorderRadius.circular(15)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundColor: black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Center(child: Text('Available Sizes')),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                    value: selectedSizes.contains('S'),
                    onChanged: (value) => changeSelectedSizes('S')),
                Text('S'),
                Checkbox(
                    value: selectedSizes.contains('M'),
                    onChanged: (value) => changeSelectedSizes('M')),
                Text('M'),
                Checkbox(
                    value: selectedSizes.contains('L'),
                    onChanged: (value) => changeSelectedSizes('L')),
                Text('L'),
                Checkbox(
                    value: selectedSizes.contains('XL'),
                    onChanged: (value) => changeSelectedSizes('XL')),
                Text('XL'),
                Checkbox(
                    value: selectedSizes.contains('XXL'),
                    onChanged: (value) => changeSelectedSizes('XXL')),
                Text('XXL'),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Sale'),
                    SizedBox(width: 10,),
                    Switch(value: onSale, onChanged: (value){
                      setState(() {
                        onSale = value;
                      });
                    })
                  ],
                ),

                Row(
                  children: <Widget>[
                    Text('Featured'),
                    SizedBox(width: 10,),
                    Switch(value: featured, onChanged: (value){
                      setState(() {
                        featured = value;
                      });
                    })
                  ],
                )
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Enter a product name with 10 characters at maximum',
              textAlign: TextAlign.center,
              style: TextStyle(color: redAccent, fontSize: 12),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(hintText: widget.product.name),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the product name';
                  } else if (value.length > 10) {
                    return 'Product name cant have more then 10 letters';
                  }
                  return null;
                },
              ),
            ),

//          For SELECT CATEGORY & BRAND
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category',
                    style: TextStyle(color: redAccent),
                  ),
                ),
                DropdownButton(
                  items: categoriesDropDown,
                  onChanged: changeSelectedCategory,
                  value: _currentCategory,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Brand',
                    style: TextStyle(color: redAccent),
                  ),
                ),
                DropdownButton(
                  items: brandsDropDown,
                  onChanged: changeSelectedBrand,
                  value: _currentBrand,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: productQtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: widget.product.quantity.toString()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the quantity';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: widget.product.price.toString()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the quantity';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                controller: productDescController,
                decoration: InputDecoration(hintText: widget.product.description),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the product description';
                  }
                  return null;
                },
              ),
            ),
//          FOR SELECT BRAND
/*//          For SELECT CATEGORY
            Visibility(
                visible: _currentCategory != null || _currentCategory == '',
                child: Text(_currentCategory ?? 'null',
                    style: TextStyle(color: redAccent))),

//          TYPE SUGGESTION SEARCHING Categories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    decoration: InputDecoration(hintText: 'add category')),
                suggestionsCallback: (pattern) async {
                  return await _categoryService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.category_outlined),
                    title: Text(suggestion['category']),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _currentCategory = suggestion['category'];
                  });
                },
              ),
            ),

//          FOR SELECT BRAND
            Visibility(
                visible: _currentBrand != null || _currentBrand == '',
                child: Text(_currentBrand ?? 'null',
                    style: TextStyle(color: redAccent))),

//          TYPE SUGGESTION SEARCHING Brands
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    decoration: InputDecoration(hintText: 'add brand')),
                suggestionsCallback: (pattern) async {
                  return await _brandService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.category_outlined),
                    title: Text(suggestion['brand']),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _currentBrand = suggestion['brand'];
                  });
                },
              ),
            ),*/

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  color: redAccent,
                  textColor: white,
                  onPressed: () {
                    validateAndUpdate();
                    productProvider.loadProducts();
/*                    setState(() {
                      productProvider.loadProducts();
                    });*/
                  },
                  child: Text('Update Product')),
            )
          ],
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print('_getCategories: ${data.length}');
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data()['category'];
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrand();
    print('_getBrand: ${data.length}');
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropDown();
      _currentBrand = brands[0].data()['brand'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() {
      _currentBrand = selectedBrand;
    });
  }

  changeSelectedSizes(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  Widget _displayImage1() {
    if (_image1 == null) {
      return /*Image.network(widget.product.imageUrl, fit: BoxFit.fill, width: double.infinity);*/
        Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.product.imageUrl,
            fit: BoxFit.fill,
            height: 100,
            width: double.infinity,
          ),
        );
    } else {
      return Image.file(_image1, fit: BoxFit.fill, width: double.infinity);
    }
  }

  void validateAndUpdate() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_displayImage1() != null) {
        if (selectedSizes.isNotEmpty && colors.isNotEmpty) {
          String imageUrl1;

          final firebase_storage.FirebaseStorage storage =
              firebase_storage.FirebaseStorage.instance;

          String old_imgRef = widget.product.imageRef;
          String productId = widget.product.id;
          String oldImage_Url = widget.product.imageUrl;
          if(_image1 == null){
            _productService.updateProduct(
              productId,
              productNameController.text,
              priceController.text,
              productDescController.text,
              selectedSizes,
              colors,
              oldImage_Url,
              old_imgRef,
              productQtyController.text,
              _currentCategory,
              _currentBrand,
              onSale,
              featured
            );
            _formKey.currentState.reset();
            setState(() {
              isLoading = false;
            });
            /*Navigator.pop(context);*/
            changeScreen(context, ProductList());
            Fluttertoast.showToast(msg: 'Product has been updated');
          }else{
            await storage.ref(old_imgRef).delete();
            final String picture1 =
                '${DateTime
                .now()
                .millisecondsSinceEpoch
                .toString()}.jpg';
            firebase_storage.UploadTask uploadTask1 =
                storage.ref().child(picture1).putFile(_image1) ?? "";

            firebase_storage.TaskSnapshot snapshot1 =
            await uploadTask1.then((snapshot) => snapshot);
            uploadTask1.then((snapshot) async {
              imageUrl1 = await snapshot1.ref.getDownloadURL();

              _productService.updateProduct(
                  productId,
                  productNameController.text,
                  priceController.text,
                  productDescController.text,
                  selectedSizes,
                  colors,
                  imageUrl1,
                  picture1,
                  productQtyController.text,
                  _currentCategory,
                  _currentBrand,
                  onSale,
                  featured
              );
            _formKey.currentState.reset();
            setState(() {
              isLoading = false;
            });
            /*Navigator.pop(context);*/
              changeScreen(context, ProductList());
            Fluttertoast.showToast(msg: 'Product has been updated');
            });
          }

        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Colors and Size cannot be empty');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Sorry, all the images must be provided');
      }
    }
  }
}
