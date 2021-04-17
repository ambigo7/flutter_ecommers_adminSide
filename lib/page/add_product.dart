import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//PACKAGE TYPE SUGGESTION
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

//PACKAGE IMAGE PICKER
import 'package:image_picker/image_picker.dart';

import 'package:lets_shop_admin/service/category.dart';
import 'package:lets_shop_admin/service/brand.dart';
import 'package:lets_shop_admin/service/product.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productQtyController = TextEditingController();

  final priceController = TextEditingController();

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<String> selectedSizes = <String>[];

  File _image1;
  File _image2;
  File _image3;
  final picker = ImagePicker();

  bool isLoading= false;

  String _currentCategory;
  String _currentBrand;

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
  Future getImage(int imageNumber) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File tmpImg = await File(pickedFile.path);
    /*File tmpImg = File(pickedFile.path);*/
    /*tmpImg = await tmpImg.copy(tmpImg.path);*/

    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tmpImg);
        break;
      case 2:
        setState(() => _image2 = tmpImg);
        break;
      case 3:
        setState(() => _image3 = tmpImg);
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.1,
        title: Text(
          'Add product',
          style: TextStyle(color: redAccent),
        ),
        //background nya masih white
        leading: Icon(
          Icons.close,
          color: black,
        ),
      ),
      body: Form(
        key: _formKey,
        child: isLoading ? Center(child: CircularProgressIndicator())
            : ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.3), width: 2.5),
                      onPressed: () {
                        getImage(1);
                      },
                      child: _displayImage1(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.3), width: 2.5),
                      onPressed: () {
                        getImage(2);
                      },
                      child: _displayImage2(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.3), width: 2.5),
                      onPressed: () {
                        getImage(3);
                      },
                      child: _displayImage3(),
                    ),
                  ),
                ),
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
                decoration: InputDecoration(hintText: 'Product Name'),
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
                decoration: InputDecoration(hintText: 'Quantity'),
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
                decoration: InputDecoration(hintText: 'Price'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the quantity';
                  }
                  return null;
                },
              ),
            ),

            Center(child: Text('Available Sizes')),

            Row(
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
              children: <Widget>[
                Checkbox(
                    value: selectedSizes.contains('32'),
                    onChanged: (value) => changeSelectedSizes('32')),
                Text('32'),
                Checkbox(
                    value: selectedSizes.contains('34'),
                    onChanged: (value) => changeSelectedSizes('34')),
                Text('34'),
                Checkbox(
                    value: selectedSizes.contains('36'),
                    onChanged: (value) => changeSelectedSizes('36')),
                Text('36'),
                Checkbox(
                    value: selectedSizes.contains('37'),
                    onChanged: (value) => changeSelectedSizes('37')),
                Text('37'),
                Checkbox(
                    value: selectedSizes.contains('38'),
                    onChanged: (value) => changeSelectedSizes('38')),
                Text('38'),
                Checkbox(
                    value: selectedSizes.contains('39'),
                    onChanged: (value) => changeSelectedSizes('39')),
                Text('39'),
              ],
            ),

            Row(
              children: <Widget>[
                Checkbox(
                    value: selectedSizes.contains('40'),
                    onChanged: (value) => changeSelectedSizes('40')),
                Text('40'),
                Checkbox(
                    value: selectedSizes.contains('41'),
                    onChanged: (value) => changeSelectedSizes('41')),
                Text('41'),
                Checkbox(
                    value: selectedSizes.contains('42'),
                    onChanged: (value) => changeSelectedSizes('42')),
                Text('42'),
                Checkbox(
                    value: selectedSizes.contains('43'),
                    onChanged: (value) => changeSelectedSizes('43')),
                Text('43'),
                Checkbox(
                    value: selectedSizes.contains('44'),
                    onChanged: (value) => changeSelectedSizes('44')),
                Text('44'),
                Checkbox(
                    value: selectedSizes.contains('45'),
                    onChanged: (value) => changeSelectedSizes('45')),
                Text('45'),
              ],
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
                    validateAndUpload();
                  },
                  child: Text('Add Product')),
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
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 50.0),
        child: new Icon(Icons.add, color: grey),
      );
    } else {
      return Image.file(_image1, fit: BoxFit.fill, width: double.infinity);
    }
  }

  Widget _displayImage2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 50.0),
        child: new Icon(Icons.add, color: grey),
      );
    } else {
      return Image.file(_image2, fit: BoxFit.fill, width: double.infinity);
    }
  }

  Widget _displayImage3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 50.0),
        child: new Icon(Icons.add, color: grey),
      );
    } else {
      return Image.file(_image3, fit: BoxFit.fill, width: double.infinity);
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_image1 != null && _image2 != null && _image3 != null) {
        if (selectedSizes.isNotEmpty) {
          String imageUrl1;
          String imageUrl2;
          String imageUrl3;

          final firebase_storage.FirebaseStorage storage =
              firebase_storage.FirebaseStorage.instance;

          final String picture1 =
              '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          firebase_storage.UploadTask uploadTask1 =
              storage.ref().child(picture1).putFile(_image1);

          final String picture2 =
              '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          firebase_storage.UploadTask uploadTask2 =
              storage.ref().child(picture2).putFile(_image2);

          final String picture3 =
              '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          firebase_storage.UploadTask uploadTask3 =
              storage.ref().child(picture3).putFile(_image3);

          firebase_storage.TaskSnapshot snapshot1 =
              await uploadTask1.then((snapshot) => snapshot);
          firebase_storage.TaskSnapshot snapshot2 =
              await uploadTask2.then((snapshot) => snapshot);

          uploadTask3.then((snapshot3) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();
            imageUrl3 = await snapshot3.ref.getDownloadURL();
            List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];
            print(imageList);

            _productService.uploadProduct(
                productName: productNameController.text,
                price: double.parse(priceController.text),
                sizes: selectedSizes,
                images: imageList,
                quantity: int.parse(productQtyController.text));
            _formKey.currentState.reset();
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: 'Product added successfully');
            Navigator.pop(context);
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'select at leat one size');
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
