import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

import 'package:lets_shop_admin/service/brand.dart';
import 'package:lets_shop_admin/service/category.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  Color active = Colors.deepOrangeAccent[700];
  Color noActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();

  //  ====CREATE MONEY CURRENCY FORMATTER====
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedPage = Page.dashboard;
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
                        Icons.sort,
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
                child: GridView(
              gridDelegate:
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
                        '7',
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
                          icon: Icon(Icons.category_outlined),
                          label: Text('Categories')),
                      subtitle: Text(
                        '20',
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
                          '120',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  ),
                ),
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
                          label: Text('Ordes')),
                      subtitle: Text(
                        '10',
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
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add product'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history_outlined),
              title: Text('Product list'),
              onTap: () {},
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
              leading: Icon(Icons.category_outlined),
              title: Text('Category list'),
              onTap: () {},
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
            ListTile(
              leading: Icon(Icons.library_books_outlined),
              title: Text('Add Product brand list'),
              onTap: () {},
            ),
            Divider()
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
            child: Text('ADD',
                style: TextStyle(color: active))),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel',
                style: TextStyle(color: active)))
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
            child: Text('ADD',
                style: TextStyle(color: active)
            )
        ),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: active),
            )
        )
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
