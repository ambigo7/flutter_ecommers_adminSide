
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';
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
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();
  UserService _userService = UserService();
  OrderService _orderService = OrderService();

  Page _selectedPage = Page.dashboard;
  Color active = Colors.deepOrangeAccent[700];
  Color noActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();

  //  ====CREATE MONEY CURRENCY FORMATTER====
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  int countCategory;
  int countBrand;
  int countProduct;
  int countUser;
  int countOrder;

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print('${data.length}');
    setState(() {
      countCategory = data.length;
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrand();
    print('${data.length}');
    setState(() {
      countBrand = data.length;
    });
  }

  _getProducts() async {
    List<DocumentSnapshot> data = await _productService.getDashboard_products();
    print('${data.length}');
    setState(() {
      countProduct = data.length;
    });
  }

  _getUsers() async {
    List<DocumentSnapshot> data = await _userService.getUsers();
    print('${data.length}');
    setState(() {
      countUser = data.length;
    });
  }

  _getOrders() async {
    List<DocumentSnapshot> data = await _orderService.getOrders();
    print('${data.length}');
    setState(() {
      countOrder = data.length;
    });
  }

  @override
  void initState() {
    _getCategories();
    _getBrands();
    _getProducts();
    _getUsers();
    _getOrders();
  }


  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedPage = Page.dashboard;
                          productProvider.loadProducts();
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
                //TODO: gimana caranya biar bisa panggil list firebase terus di hitung harga total product
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
                        '$countUser',
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
                        '$countProduct',
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
                        '$countBrand',
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
                        '13',
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
                        '$countOrder',
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
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.shopping_cart_outlined),
              title: Text('Manage Orders'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Add product'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit Product'),
              onTap: () {
                productProvider.loadProducts();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProductList()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Add Category'),
              onTap: () {
                _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Add Brand'),
              onTap: () {
                _brandAlert();
              },
            ),
            Divider(),
          ],
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
}
