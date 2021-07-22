import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/component/custom_text.dart';
import 'package:lets_shop_admin/models/lens.dart';
import 'package:lets_shop_admin/provider/lens_provider.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class EditLens extends StatefulWidget {
  final LensModel lens;

  const EditLens({Key key, this.lens}) : super(key: key);

  @override
  _EditLensState createState() => _EditLensState();
}

class _EditLensState extends State<EditLens> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController lensNameController = TextEditingController();
  TextEditingController lensBrandController = TextEditingController();
  var priceController = TextEditingController();
  var oldPriceController = TextEditingController();
  TextEditingController lensDescController = TextEditingController();

  List<String> colors = <String>[];
  bool onSale;

  File _image;
  final picker = ImagePicker();

  bool isLoading = false;

  @override
  void initState() {
    onSale = widget.lens.sale;
    super.initState();
  }

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
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final lensProvider = Provider.of<LensProvider>(context);

    lensNameController = TextEditingController(text: widget.lens.name);
    lensBrandController = TextEditingController(text: widget.lens.brand);
    priceController = TextEditingController(text: widget.lens.price.toString());
    oldPriceController = TextEditingController(text: onSale ? widget.lens.oldPrice.toString() : 0.toString());
    lensDescController = TextEditingController(text: widget.lens.description);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.1,
        title: Padding(
          padding: const EdgeInsets.only(left:80),
          child: Text(
            'Update Eyeglass',
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
                      child: Text('Update Lens')),
                )
              ]
          ),
      ),
    );
  }

  Widget _displayImage() {
    if (_image == null) {
      return /*Image.network(widget.product.imageUrl, fit: BoxFit.fill, width: double.infinity);*/
        Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.lens.imageUrl,
            fit: BoxFit.fill,
            height: 100,
            width: double.infinity,
          ),
        );
    } else {
      return Image.file(_image, fit: BoxFit.fill, width: double.infinity);
    }
  }

  void validateAndUpload() async{
    final lensProvider = Provider.of<LensProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    String _colors = colors.toString();
    String _colorsRemove = _colors.replaceAll('[', '');
    String _selectedColors= _colorsRemove.replaceAll(']', '');
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_displayImage() != null && colors.length == 1) {
        String old_imgRef = widget.lens.imageRef;
        String lensId = widget.lens.id;
        String oldImage_Url = widget.lens.imageUrl;

        if(_image == null){
          print('SelectedColors update : $_selectedColors');
          bool updateLens1 = await lensProvider.updateLens(
              lensId, lensNameController.text, priceController.text, oldPriceController.text,
              lensDescController.text, _selectedColors, _image, lensBrandController.text, onSale,
              oldImageUrl: oldImage_Url, oldImageRef: old_imgRef);
          print('update image : $_image');
          print('update status : $updateLens1');
          if(updateLens1) {
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: CustomText(
                  text: "Lens has been updated", color: blue),
            ));
            productProvider.removeColor(_selectedColors);
            // changeScreen(context, Admin(page: 'manage',));
            //Dua kali balik ke page sebelumnya
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() {
              isLoading = false;
            });
          }else{
            productProvider.removeColor(_selectedColors);
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: CustomText(
                  text: "Update lens failed", color: blue),
            ));
            setState(() {
              isLoading = false;
            });
          }
        }else{
          print('SelectedColors : $_selectedColors');
          bool updateLens2 = await lensProvider.updateLens(
              lensId, lensNameController.text, priceController.text, oldPriceController.text,
            lensDescController.text, _selectedColors, _image, lensBrandController.text, onSale, oldImageRef: old_imgRef);
          print('update image : $_image');
          print('upload status : $updateLens2');
          if(updateLens2) {
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: CustomText(
                  text: "Lens has been updated", color: blue),
            ));
            productProvider.removeColor(_selectedColors);
            /*changeScreen(context, Admin(page: 'manage',));*/
            //Dua kali balik ke page sebelumnya
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() {
              isLoading = false;
            });
          }else{
            productProvider.removeColor(_selectedColors);
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: CustomText(
                  text: "Update lens failed", color: blue),
            ));
            setState(() {
              isLoading = false;
            });
          }
        }
      }else{
        _key.currentState.showSnackBar(SnackBar(
          backgroundColor: white,
          content: CustomText(text: "Sorry, all the images must be provided and color cannot empty", color: blue),
        ));
        setState(() {
          isLoading = false;
        });
      }
    } else {
      productProvider.removeColor(_selectedColors);
      /*Fluttertoast.showToast(msg: 'Sorry, all the images must be provided');*/
      _key.currentState.showSnackBar(SnackBar(
        backgroundColor: white,
        content: CustomText(text: "Update Failed. Please, try again", color: blue),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }
}
