
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/component/custom_text.dart';
import 'package:lets_shop_admin/component/lens_list.dart';
import 'package:lets_shop_admin/component/order_list.dart';
import 'package:lets_shop_admin/provider/lens_provider.dart';
import 'package:lets_shop_admin/provider/order_provider.dart';
import 'package:lets_shop_admin/provider/products_provider.dart';
import 'package:lets_shop_admin/provider/user_provider.dart';
import 'package:lets_shop_admin/screens/add_lens.dart';
import 'file:///D:/App%20Flutter%20build/lets_shop_admin/lib/component/product_list.dart';

import 'package:lets_shop_admin/service/brand.dart';
import 'package:lets_shop_admin/service/category.dart';
import 'package:provider/provider.dart';

import 'add_product.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  final String page;

  const Admin({Key key, this.page}) : super(key: key);
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();

  Page _selectedPage = Page.dashboard;

  selectedPageFromAnotherClass(String _select){
    if(_select == "dashboard"){
      setState(() {
        _selectedPage = Page.dashboard;
      });
    }else if(_select == "manage"){
      setState(() {
        _selectedPage = Page.manage;
      });
    }else{
      setState(() {
        _selectedPage = Page.dashboard;
      });
    }
  }


  bool _expansionProductClicked = false;
  bool _expansionEyeClicked = false;

  Color active = blue;
  Color noActive = grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();

  bool isLoading = false;

  //  ====CREATE MONEY CURRENCY FORMATTER====
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  @override
  void initState() {
    selectedPageFromAnotherClass(widget.page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
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
                          userProvider.getCountUsers();
                          orderProvider.getPendingOrder();
                          orderProvider.getOrdersIncomplete();
                          orderProvider.getSold();
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
                          orderProvider.getPendingOrder();
                          orderProvider.getOrdersIncomplete();
                        });
                      },
                      icon: orderProvider.countOrderPending > 0
                          ? Badge(
                          position: BadgePosition.topEnd(top: -13, end: -8),
                          animationDuration: Duration(milliseconds: 500),
                            animationType: BadgeAnimationType.slide,
                          badgeContent: Text(
                              orderProvider.countOrderPending.toString(),
                              style: TextStyle(color: Colors.white)),
                          child: Icon(Icons.settings, color: _selectedPage == Page.manage ? active : noActive,))
                          : Icon(Icons.settings, color: _selectedPage == Page.manage ? active : noActive,),/*Icon(
                        Icons.settings,
                        color: _selectedPage == Page.manage ? active : noActive,
                      )*/
                      label: Text('Manage')))
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: isLoading ? Loading()
            :  GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details){
              if (details.primaryVelocity > 0) {
                // User swiped Left
                setState(() {
                  _selectedPage = Page.dashboard;
                });
              } else if (details.primaryVelocity < 0) {
                // User swiped Right
                setState(() {
                  _selectedPage = Page.manage;
                });
              }
            },
            child: _loadScreen())
    );
  }

  Widget _loadScreen() {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final lensProvider = Provider.of<LensProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            //TODO: Masih belum ketemu caranya hitung revenue, next update aja!!!!
/*            ListTile(
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
            ),*/
            Expanded(
                child: GridView(gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: grey,),
                      boxShadow: [BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.3))],
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                    ),
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.person_outline),
                          label: Text('Users')),
                      subtitle: Text(
                        '${userProvider.countUser}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: grey,),
                      boxShadow: [BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.3))],
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                    ),
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.track_changes),
                          label: Text("Products")),
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
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: grey,),
                      boxShadow: [BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.3))],
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                    ),
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
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: grey,),
                      boxShadow: [BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.3))],
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                    ),
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.tag_faces_outlined),
                          label: Text('Sold')),
                      subtitle: Text(
                        '${productProvider.countSold ?? 0}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: grey,),
                      boxShadow: [BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.3))],
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                    ),
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.shopping_cart_outlined),
                          label:  CustomText(
                            text: 'Orders \nIncomplete',
                            size: 14,
                            color: grey,
                            align: TextAlign.center,)),
                      subtitle: Text(
                        '${orderProvider.countOrderIncomplete  ?? 0}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: grey,),
                      boxShadow: [BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.3))],
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                    ),
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.timer, color: redAccent, size: 20,),
                          label: CustomText(
                            text: 'Pending\nValidation',
                            size: 14,
                            color: redAccent,
                            weight: FontWeight.bold,
                            align: TextAlign.center,)),
                      subtitle: Text(
                        '${orderProvider.countOrderPending ?? 0}',
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
                leading: orderProvider.countOrderPending > 0
                        ? Badge(
                            position: BadgePosition.topEnd(top: -13, end: -8),
                          animationDuration: Duration(milliseconds: 500),
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                                orderProvider.countOrderPending.toString(),
                                style: TextStyle(color: Colors.white)),
                            child: Icon(Icons.shopping_cart_outlined))
                        : Icon(Icons.shopping_cart_outlined),
                title: Text('Orders'),
                onTap: (){
                  changeScreen(context, OrderScreen());
                },
              ),
              Divider(),
              Theme(
                data: ThemeData(accentColor: _expansionProductClicked ? active : noActive,),
                child: ExpansionTile(
                  leading: Icon(Icons.track_changes, color: _expansionProductClicked ? active : noActive,),
                  title: CustomText(text: 'Product', color: _expansionProductClicked ? active : black,),
                  childrenPadding: EdgeInsets.only(left: 40),
                  onExpansionChanged: (value){
                    setState(() {
                      _expansionProductClicked = value;
                    });
                  },
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.add_circle_outline),
                      title: Text('Add Product'),
                      onTap: () {
                        changeScreen(context, AddProduct());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.view_list),
                      title: Text('Update & Delete Product'),
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        productProvider.reloadProducts();
                        changeScreen(context, ProductList());
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ],
                ),
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
              Theme(
                data: ThemeData(accentColor: _expansionEyeClicked ? active : noActive,),
                child: ExpansionTile(
                  leading: Icon(Icons.assignment_turned_in_outlined, color: _expansionEyeClicked  ? active : noActive,),
                  title: CustomText(text: 'Lens', color: _expansionEyeClicked  ? active : black,),
                  childrenPadding: EdgeInsets.only(left: 40),
                  onExpansionChanged: (value){
                    setState(() {
                      _expansionEyeClicked  = value;
                    });
                  },
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.add_circle_outline),
                      title: Text('Add Lens'),
                      onTap: () {
                        changeScreen(context, AddLens());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.view_list),
                      title: Text('Update & Delete Lens'),
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        lensProvider.reloadLens();
                        changeScreen(context, LensList());
                        setState(() {
                          isLoading = false;
                        });

                      },
                    ),
                  ],
                ),
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
}
