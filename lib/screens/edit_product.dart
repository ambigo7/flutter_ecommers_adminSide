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
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/component/custom_text.dart';
import 'package:lets_shop_admin/component/product_list.dart';
import 'package:lets_shop_admin/models/product.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';

import 'package:lets_shop_admin/service/category.dart';
import 'package:lets_shop_admin/service/brand.dart';
import 'package:lets_shop_admin/service/product.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'admin.dart';

class EditProduct extends StatefulWidget {
  final ProductModel product;

  const EditProduct({Key key, this.product}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productBrandController = TextEditingController();
  var priceController = TextEditingController();
  var oldPriceController = TextEditingController();
  TextEditingController productDescController = TextEditingController();

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
  <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<String> selectedSizes = <String>[];
  List<String> colors = <String>[];
  bool onSale;
  bool featured;

  File _image1;
  final picker = ImagePicker();

  bool isLoading = false;

/*  String _currentCategory = "";
  String _currentBrand = "";*/


  @override
  void initState() {
/*    _getCategories();
    _getBrands();*/
    onSale = widget.product.sale;
    featured = widget.product.featured;
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

    productNameController = TextEditingController(text: widget.product.name);
    productBrandController = TextEditingController(text: widget.product.brand);
    priceController = TextEditingController(text: widget.product.price.toString());
    oldPriceController = TextEditingController(text: onSale ? widget.product.oldPrice.toString() : 0.toString());
    productDescController = TextEditingController(text: widget.product.description);

/*    onSale = widget.product.sale;
    featured = widget.product.featured;*/
    bool _switchSale = widget.product.sale;
    bool _switchFeatured = widget.product.featured;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.1,
        title: Padding(
          padding: const EdgeInsets.only(left:80),
          child: Text(
            'Update Product',
            style: TextStyle(color: blue),
          ),
        ),
        //background nya masih white
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: blue,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading ? Loading()
          : Form(
        key: _formKey,
        child: ListView(
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

            Center(child: Text('You can only choose one color')),

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

/*            Center(child: Text('Available Sizes')),

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
            ),*/

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
                        print('onSale value global : $onSale');
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
                        print('featured value global : $featured');
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
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: CustomText(
                text: 'Product Name',
                color: grey,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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

            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: CustomText(
                text: 'Brand Name',
                color: grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: TextFormField(
                controller: productBrandController,
                decoration: InputDecoration(hintText: widget.product.brand),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the Brand name';
                  }
                  return null;
                },
              ),
            ),
//          For SELECT CATEGORY & BRAND
/*            Row(
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
            ),*/

/*            Padding(
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
            ),*/

            Visibility(
              visible: onSale ? true : false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      text: 'Old Price',
                      color: grey,
                    ),
                    TextFormField(
                      controller: oldPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: widget.product.oldPrice.toString()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the old price';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: CustomText(
                text: 'Price Name',
                color: grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: widget.product.price.toString()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the price';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: CustomText(
                text: 'Product Description',
                color: grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                  color: blue,
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

  /* _getCategories() async {
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
  }*/

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
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    String _colors = colors.toString();
    String _colorsRemove = _colors.replaceAll('[', '');
    String _selectedColors= _colorsRemove.replaceAll(']', '');
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_displayImage1() != null && colors.length == 1) {
        String old_imgRef = widget.product.imageRef;
        String productId = widget.product.id;
        String oldImage_Url = widget.product.imageUrl;
        if(_image1 == null){
          print('SelectedColors update : $_selectedColors');
          bool updateProduct1 = await productProvider.updateProduct(
              productId, productNameController.text, priceController.text, oldPriceController.text,
              productDescController.text, _selectedColors, _image1,
              productBrandController.text, onSale, featured, oldImageUrl: oldImage_Url, oldImageRef: old_imgRef);
          print('update image : $_image1');
          print('update status : $updateProduct1');
          if(updateProduct1) {
            productProvider.removeColor(_selectedColors);
            /*changeScreen(context, Admin());*/
            changeScreen(context, ProductList());
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: CustomText(
                  text: "Product has been updated", color: blue),
            ));
            setState(() {
              isLoading = false;
            });
          }else{
            productProvider.removeColor(_selectedColors);
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: CustomText(
                  text: "Update product failed", color: blue),
            ));
            setState(() {
              isLoading = false;
            });
          }
          /*Fluttertoast.showToast(msg: 'Product has been updated');*/
        }else{
          print('SelectedColors : $_selectedColors');
          bool updateProduct2 = await productProvider.updateProduct(
              productId, productNameController.text, priceController.text,oldPriceController.text,
              productDescController.text, _selectedColors, _image1,
              productBrandController.text, onSale, featured, oldImageRef: old_imgRef);
          print('update image : $_image1');
          print('upload status : $updateProduct2');
          if(updateProduct2) {
            productProvider.removeColor(_selectedColors);
            changeScreen(context, Admin());
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: CustomText(
                  text: "Product has been updated", color: blue),
            ));
            setState(() {
              isLoading = false;
            });
          }else{
            productProvider.removeColor(_selectedColors);
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: CustomText(
                  text: "Update product failed", color: blue),
            ));
            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });
        /*Fluttertoast.showToast(msg: 'Sorry, all the images must be provided');*/
        _key.currentState.showSnackBar(SnackBar(
          backgroundColor: white,
          content: CustomText(text: "Sorry, all the images must be provided and color cannot empty", color: blue),
        ));
      }
    }
  }
}
