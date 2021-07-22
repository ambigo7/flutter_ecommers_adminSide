import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/component/custom_text.dart';
import 'package:lets_shop_admin/provider/lens_provider.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';
import 'package:provider/provider.dart';

import 'admin.dart';


class AddLens extends StatefulWidget {
  @override
  _AddLensState createState() => _AddLensState();
}

class _AddLensState extends State<AddLens> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController lensNameController;
  TextEditingController lensBrandController;
  TextEditingController priceController;
  TextEditingController oldPriceController;
  TextEditingController lensDescController;

  List<String> colors = <String>[];

  File _image;
  final picker = ImagePicker();

  bool onSale;
  bool isLoading = false;

  //GET IMAGE
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File tmpImg = await File(pickedFile.path);
    /*File tmpImg = File(pickedFile.path);*/
    /*tmpImg = await tmpImg.copy(tmpImg.path);*/

    setState(() => _image = tmpImg);
  }

  @override
  void initState() {
    _image = null;
    lensNameController  = TextEditingController();
    lensBrandController = TextEditingController();
    lensDescController = TextEditingController();
    priceController = TextEditingController();
    oldPriceController = TextEditingController();
    onSale  = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.1,
        title: Padding(
          padding: const EdgeInsets.only(left:80),
          child: Text(
            'Add Eyeglass',
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
      body: Form(
        key: _formKey,
        child: isLoading ? Loading()
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
                          child: _displayImage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Sale'),
                  SizedBox(width: 10,),
                  Switch(
                      value: onSale,
                      activeColor: blue,
                      onChanged: (value){
                    setState(() {
                      onSale = value;
                      print('onSale value : $onSale');
                    });
                  })
                ],
              ),

              SizedBox(height: 8.0),
              Text(
                'Enter a lens name with 10 characters at maximum',
                textAlign: TextAlign.center,
                style: TextStyle(color: redAccent, fontSize: 12),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: lensNameController,
                  decoration: InputDecoration(hintText: 'Lens Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 10) {
                      return 'Lens name cant have more then 10 letters';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: lensBrandController,
                  decoration: InputDecoration(hintText: 'Brand name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the Brand name';
                    }
                    return null;
                  },
                ),
              ),

              Visibility(
                visible: onSale ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: oldPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Old Price'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must enter the old price';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Price'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the price';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  controller: lensDescController,
                  decoration: InputDecoration(hintText: 'Lens Description'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the lens description';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                    color: blue,
                    textColor: white,
                    onPressed: () {
                      validateAndUpload();
                    },
                    child: Text('Add Lens')),
              )
            ]
        ),
      ),
    );
  }

  Widget _displayImage() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 50.0),
        child: new Icon(Icons.add, color: grey),
      );
    } else {
      return Image.file(_image, fit: BoxFit.fill, width: double.infinity);
    }
  }

  void validateAndUpload() async{
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final lensProvider = Provider.of<LensProvider>(context, listen: false);
    String _colors = colors.toString();
    String _colorsRemove = _colors.replaceAll('[', '');
    String _selectedColors= _colorsRemove.replaceAll(']', '');
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_image != null && colors.length == 1) {
        bool uploadLens = await lensProvider.addLens(lensNameController.text, priceController.text, oldPriceController.text,
            lensDescController.text, _selectedColors, _image, lensBrandController.text, onSale);
        print('upload status : $uploadLens');
        if(uploadLens != false){
          lensProvider.getLens();
          productProvider.removeColor(_selectedColors);
          /*changeScreen(context, Admin(page: 'manage',));*/
          setState(() {
            _image = null;
            lensNameController  = TextEditingController();
            lensBrandController = TextEditingController();
            lensDescController = TextEditingController();
            priceController = TextEditingController();
            oldPriceController = TextEditingController();
            onSale  = false;
            isLoading = false;
          });
          _key.currentState.showSnackBar(SnackBar(
            backgroundColor: white,
            content: CustomText(text: "Lens added successfully", color: blue),
          ));
        }else{
          productProvider.removeColor(_selectedColors);
          setState(() {
            isLoading = false;
          });
          _key.currentState.showSnackBar(SnackBar(
            backgroundColor: white,
            content: CustomText(text: "Adding lens failed", color: blue),
          ));
        }
      } else {
        productProvider.removeColor(_selectedColors);
        setState(() {
          isLoading = false;
        });
        /*Fluttertoast.showToast(msg: 'Colors and Size cannot be empty');*/
        _key.currentState.showSnackBar(SnackBar(
          backgroundColor: white,
          content: CustomText(text: "Sorry, all the images must be provided and color cannot empty", color: blue),
        ));
      }
    } else {
      productProvider.removeColor(_selectedColors);
      /*Fluttertoast.showToast(msg: 'Sorry, all the images must be provided');*/
      _key.currentState.showSnackBar(SnackBar(
        backgroundColor: white,
        content: CustomText(text: "Upload Failed. Please, try again", color: blue),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }
}
