
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';
import 'file:///D:/App%20Flutter%20build/lets_shop_admin/lib/component/product_list.dart';

import 'package:lets_shop_admin/service/brand.dart';
import 'package:lets_shop_admin/service/category.dart';
import 'package:lets_shop_admin/service/order.dart';
import 'package:lets_shop_admin/service/product.dart';
import 'package:lets_shop_admin/service/user.dart';
import 'package:provider/provider.dart';

import 'add_product.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService(); //TODO: buat database brand lensa!!!

  Page _selectedPage = Page.dashboard;
  Color active = blue;
  Color noActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();

  //  ====CREATE MONEY CURRENCY FORMATTER====
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');



  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    String _lenghtProduct = productProvider.products.length.toString();
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedPage = Page.dashboard;
                          productProvider.getBrands();
                          productProvider.getProducts();
                          productProvider.getUsers();
                          productProvider.getOrders();
                          productProvider.getSold();
                        });
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color:
                            _selectedPage == Page.dashboard ? active : noActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedPage = Page.manage;
                          productProvider.getOrders();
                        });
                      },
                      icon: Icon(
                        Icons.perm_data_setting_outlined,
                        color: _selectedPage == Page.manage ? active : noActive,
                      ),
                      label: Text('Manage')))
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    final productProvider = Provider.of<ProductProvider>(context);
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.check_outlined,
                  size: 30.0,
                  color: Colors.green,
                ),
                //TODO: liat alur cart di letshop admin buat itung seluruh Revenue
                label: Text('${formatCurrency.format(150000)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
                child: GridView(gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.person_outline),
                          label: Text('Users')),
                      subtitle: Text(
                        '${productProvider.countUser}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.track_changes),
                          label: Text("Producs")),
                      subtitle: Text(
                        '${productProvider.countProduct}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.assignment_turned_in_outlined),
                          label: Text("Brand")),
                      subtitle: Text(
                        '${productProvider.countBrand}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),

/*                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.category_outlined),
                          label: Text('Categories')),
                      subtitle: Text(
                        '$countCategory',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),*/

                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.tag_faces_outlined),
                          label: Text('Sold')),
                      subtitle: Text(
                        '${productProvider.countSold}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.shopping_cart_outlined),
                          label: Text('Orders')),
                      subtitle: Text(
                        '${productProvider.countOrder}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.close_outlined),
                          label: Text('return')),
                      subtitle: Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        );
        break;
      case Page.manage:
        final productProvider = Provider.of<ProductProvider>(context);
        return Center(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: productProvider.countOrder > 0
                        ? Badge(
                            position: BadgePosition.topEnd(top: -13, end: -8),
/*                          animationDuration: Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.slide,*/
                            badgeContent: Text(
                                productProvider.countOrder.toString(),
                                style: TextStyle(color: Colors.white)),
                            child: Icon(Icons.shopping_cart_outlined))
                        : Icon(Icons.shopping_cart_outlined),
                title: Text('Orders'),
                onTap: (){

                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.track_changes),
                title: Text('Product'),
                onTap: () {
                  productModalButtom(context);
/*                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context){
                        return Container(
                          height: 200,
                          child: ListView(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.add_circle_outline),
                                title: Text('Add product'),
                                onTap: () {
                                  changeScreen(context, AddProduct());
                                },
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.edit_outlined),
                                title: Text('Update & Delete Product'),
                                onTap: () {
                                  productProvider.loadProducts();
                                  changeScreen(context, ProductList());
                                },
                              ),
                            ],
                          ),
                        );
                      }
                  );*/
                },
              ),
/*            Divider(),
              ListTile(
                leading: Icon(Icons.add_circle_outline),
                title: Text('Category'),
                onTap: () {
                  _categoryAlert();
                },
              ),*/
              Divider(),
              ListTile(
                leading: Icon(Icons.assignment_turned_in_outlined),
                title: Text('Brand'),
                onTap: () {
                  _brandAlert();
                },
              ),
              Divider(),
            ],
          ),
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Category cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'Add category'),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (categoryController.text != null) {
                _categoryService.createCategory(categoryController.text);
                Navigator.pop(context);
              }
              Fluttertoast.showToast(msg: 'Successfully created a category');
            },
            child: Text('ADD', style: TextStyle(color: active))),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: active)))
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _brandAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Brand cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'Add brand'),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (brandController.text != null) {
                _brandService.createBrand(brandController.text);
                Navigator.pop(context);
              }
              Fluttertoast.showToast(msg: 'Successfully created a brand');
            },
            child: Text('ADD', style: TextStyle(color: active))),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: active),
            ))
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void productModalButtom(BuildContext context){
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (_){
          return Container(
            height: 200,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.add_circle_outline),
                  title: Text('Add product'),
                  onTap: () {
                    changeScreen(context, AddProduct());
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Update & Delete Product'),
                  onTap: () {
                    productProvider.loadProducts();
                    changeScreen(context, ProductList());
                  },
                ),
              ],
            ),
          );
        }
    );
  }
}
