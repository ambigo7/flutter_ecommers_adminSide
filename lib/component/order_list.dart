import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/models/cart_item.dart';
import 'package:lets_shop_admin/models/order.dart';
import 'package:lets_shop_admin/provider/app_provider.dart';
import 'package:lets_shop_admin/provider/order_provider.dart';
import 'package:lets_shop_admin/provider/user_provider.dart';
import 'package:lets_shop_admin/screens/detail_order.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'column_builder.dart';
import 'custom_text.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {

  TabController _controller;
  int _selectedTabBar = 0;
  bool _onExpansionClicked = false;

  Color active = blue;
  Color noActive = grey;

  final _key = GlobalKey<ScaffoldState>();


  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  DateFormat dateFormat;

  List<Widget> list = [
    Tab(text: 'Pending Validation',),
    Tab(text: 'Incomplete',),
    Tab(text: 'Validation success',),
    Tab(text: 'Ready to pick up',),
    Tab(text: 'Delivery',),
    Tab(text: 'Completed'),
  ];

  var refreshState;

  @override
  void initState() {
    _controller = TabController(length: list.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedTabBar = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMd('id_ID').add_Hm();
    refreshState = ChangeNotifierProvider.value(value: OrderProvider.initialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: blue),
        backgroundColor: white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          orderProvider.getPendingOrder();
          Navigator.pop(context);
        }),
        title: CustomText(text: "List of Orders", size: 20, color: blue, weight: FontWeight.bold,),
        elevation: 0.0,
        centerTitle: true,
        bottom: TabBar(
          isScrollable: true,
          labelColor: blue,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelColor: grey,
          indicatorColor: blue,
          onTap: (index) {
            // Should not used it as it only called when tab options are clicked,
            // not when user swapped
          },
          controller: _controller,
          tabs: list,
        ),
      ),
      body: appProvider.isLoading ? Loading()
          : TabBarView(
        controller: _controller,
        children: <Widget>[
          pendingValidation(),
          incompleteOrder(),
          validationSuccessOrder(),
          readyToPickUpOrder(),
          deliveryOrder(),
          completedOrder()
        ],
      ),
    );
  }

  Widget pendingValidation(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return orderProvider.pendingOrders.length == 0 ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shopping_basket_outlined, color: grey, size: 30,),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(text: "No orders found pending validation", color: grey, weight: FontWeight.w300, size: 22,),
          ],
        )
      ],
    ) :
    ListView.builder(
        itemCount: orderProvider.pendingOrders.length,
        itemBuilder: (_, indexPendingOrders){
          OrderModel _order = orderProvider.pendingOrders[indexPendingOrders];
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'User Information'),
                            GestureDetector(
                              onTap: () async{
                                await userProvider.getUserById(id: _order.userId);
                                userInformationModal(_order.id);
                              },
                              child: Text('Click here',
                                style: TextStyle(color: Colors.blueAccent,
                                    decoration: TextDecoration.underline),),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'Order Status'),
                            CustomText(text: _order.status, color: redAccent,)
                          ],
                        ),
                        SizedBox(height: 10,),
                        //PRODUCT LIST
                        Theme(
                          data: ThemeData(accentColor: _onExpansionClicked ? active : noActive,),
                          child: ExpansionTile(
                            onExpansionChanged: (clicked){
                              setState(() {
                                _onExpansionClicked = clicked;
                              });
                            },
                            title: Row(
                              children: <Widget>[
                                Container(
                                  color: blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 40,
                                        width: 80,
                                        child: Center(child: CustomText(text: "${_order.cart.length.toString()}""x", color: white, size: 20,))
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'ID : '),
                                        CustomText(text: _order.id.toUpperCase(), weight: FontWeight.bold,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Desc : '),
                                        CustomText(text: _order.description),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Service : '),
                                        CustomText(text: _order.service),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(
                                        text: 'Message order '),
                                    _order.message.isEmpty
                                        ? CustomText(text: '---')
                                        : CustomText(text: _order.message)
                                  ],
                                ),
                              ),
                              ColumnBuilder(
                                  itemCount: _order.cart.length,
                                  itemBuilder: (_, indexCartProduct){
                                    CartItemModel _cart = _order.cart[indexCartProduct];
                                    return ListTile(
                                      leading: Container(
                                        height: 80,
                                        width: 80,
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: _order.cart[indexCartProduct].imageProduct,
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 140,
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CustomText(text: _cart.nameProduct, weight: FontWeight.bold,),
                                          Visibility(
                                            visible: _cart.nameLens.isNotEmpty,
                                            child: CustomText(
                                                text: _cart.adjustLens.isNotEmpty
                                                    ? '${_cart.nameLens} <with adjust lens>' : _cart.nameLens),
                                          ),
                                        ],
                                      ),
                                      subtitle: CustomText(text: '${formatCurrency.format(_cart.priceProduct)}',),
                                    );
                                  }),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for product', color: grey,),
                                          CustomText(text: '${formatCurrency.format(_order.totalProductPrice)}')
                                        ],
                                      ),
                                      Visibility(
                                        visible: _order.totalLensPrice != 0 ? true : false,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(text: 'Subtotal for custom lens', color: grey),
                                            CustomText(text: '${formatCurrency.format(_order.totalLensPrice)}')
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for shipping ', color: grey),
                                          CustomText(text: '${formatCurrency.format(_order.charges)}'),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        Divider(color: blue),
                        //Amount Payable
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: CustomText(text: '  Total payment '),
                            ),
                            CustomText(text: '${formatCurrency.format(_order.totalPayment)}', weight: FontWeight.bold,)
                          ],
                        ),
                        Divider(color: blue),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(text: 'Order Time              '
                                      '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.orderTime))}',
                                    color: grey,),
                                  Visibility(
                                    visible: _order.paymentTime != 0 ? true : false,
                                    child: CustomText(text: 'Payment Time        '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.paymentTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.shipTime != 0 ? true : false,
                                    child: CustomText(text: 'Ship Time                '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.completedTime != 0 ? true : false,
                                    child: CustomText(text: 'Completed Time    '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                ],
                              ),
                              Container(
                                height: 35,
                                child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: blue,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async{
                                        appProvider.changeIsLoading();
                                        await userProvider.getUserById(id: _order.userId);
                                        changeScreen(context,
                                            DetailOrder(order: _order, orderCart: _order.cart[indexPendingOrders],));
                                        _controller.animateTo(_controller.index +2, duration: Duration(milliseconds: 500));
                                        appProvider.changeIsLoading();
                                      },
                                      child: CustomText(text: 'Detail Order', color: white,),
                                    )
                                ),
                              )
                            ]
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }
  Widget incompleteOrder(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return orderProvider.incompleteOrders.length == 0 ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shopping_basket_outlined, color: grey, size: 30,),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(text: "No incomplete orders found", color: grey, weight: FontWeight.w300, size: 22,),
          ],
        )
      ],
    ) :
    ListView.builder(
        itemCount: orderProvider.incompleteOrders.length,
        itemBuilder: (_, indexIncompleteOrders){
          OrderModel _order = orderProvider.incompleteOrders[indexIncompleteOrders];
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'User Information'),
                            GestureDetector(
                              onTap: () async{
                                await userProvider.getUserById(id: _order.userId);
                                userInformationModal(_order.id);
                              },
                              child: Text('Click here',
                                style: TextStyle(color: Colors.blueAccent,
                                    decoration: TextDecoration.underline),),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'Order Status'),
                            CustomText(text: _order.status, color: redAccent,)
                          ],
                        ),
                        SizedBox(height: 10,),
                        //PRODUCT LIST
                        Theme(
                          data: ThemeData(accentColor: _onExpansionClicked ? active : noActive,),
                          child: ExpansionTile(
                            onExpansionChanged: (clicked){
                              setState(() {
                                _onExpansionClicked = clicked;
                              });
                            },
                            title: Row(
                              children: <Widget>[
                                Container(
                                  color: blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 40,
                                        width: 80,
                                        child: Center(child: CustomText(text: "${_order.cart.length.toString()}""x", color: white, size: 20,))
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'ID : '),
                                        CustomText(text: _order.id.toUpperCase(), weight: FontWeight.bold,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Desc : '),
                                        CustomText(text: _order.description),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Service : '),
                                        CustomText(text: _order.service),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(
                                        text: 'Message order '),
                                    _order.message.isEmpty
                                        ? CustomText(text: '---')
                                        : CustomText(text: _order.message)
                                  ],
                                ),
                              ),
                              ColumnBuilder(
                                  itemCount: _order.cart.length,
                                  itemBuilder: (_, indexCartProduct){
                                    CartItemModel _cart = _order.cart[indexCartProduct];
                                    return ListTile(
                                      leading: Container(
                                        height: 80,
                                        width: 80,
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: _order.cart[indexCartProduct].imageProduct,
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 140,
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CustomText(text: _cart.nameProduct, weight: FontWeight.bold,),
                                          Visibility(
                                            visible: _cart.nameLens.isNotEmpty,
                                            child: CustomText(
                                                text: _cart.adjustLens.isNotEmpty
                                                    ? '${_cart.nameLens} <with adjust lens>' : _cart.nameLens),
                                          ),
                                        ],
                                      ),
                                      subtitle: CustomText(text: '${formatCurrency.format(_cart.priceProduct)}',),
                                    );
                                  }),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for product', color: grey,),
                                          CustomText(text: '${formatCurrency.format(_order.totalProductPrice)}')
                                        ],
                                      ),
                                      Visibility(
                                        visible: _order.totalLensPrice != 0 ? true : false,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(text: 'Subtotal for custom lens', color: grey),
                                            CustomText(text: '${formatCurrency.format(_order.totalLensPrice)}')
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for shipping ', color: grey),
                                          CustomText(text: '${formatCurrency.format(_order.charges)}'),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        Divider(color: blue),
                        //Amount Payable
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: CustomText(text: '  Total payment '),
                            ),
                            CustomText(text: '${formatCurrency.format(_order.totalPayment)}', weight: FontWeight.bold,)
                          ],
                        ),
                        Divider(color: blue),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(text: 'Order Time              '
                                      '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.orderTime))}',
                                    color: grey,),
                                  Visibility(
                                    visible: _order.paymentTime != 0 ? true : false,
                                    child: CustomText(text: 'Payment Time        '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.paymentTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.shipTime != 0 ? true : false,
                                    child: CustomText(text: 'Ship Time                '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.completedTime != 0 ? true : false,
                                    child: CustomText(text: 'Completed Time    '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                ],
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: redAccent,
                                  ),
                                  onPressed: () async {
                                    appProvider.changeIsLoading();
                                    bool deleteOrder = await orderProvider.deleteOrder(orderId: _order.id);
                                    if (deleteOrder) {
                                      orderProvider.getIncompleteOrder();
                                      _key.currentState.showSnackBar(SnackBar(
                                          backgroundColor: white,
                                          content: Text("Order has been deleted!",
                                              style: TextStyle(
                                                  color: blue))));
                                      orderProvider.getIncompleteOrder();
                                      appProvider.changeIsLoading();
                                      _controller.animateTo(_controller.index +1);
                                      _controller.animateTo(_controller.index -1);
                                    } else {
                                      _key.currentState.showSnackBar(SnackBar(
                                          backgroundColor: white,
                                          content: Text("Order fail to be deleted!",
                                              style: TextStyle(
                                                  color: blue))));
                                      appProvider.changeIsLoading();
                                    }
                                  })
                            ]
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }
  Widget validationSuccessOrder(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return orderProvider.validationSuccess.length == 0 ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shopping_basket_outlined, color: grey, size: 30,),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(text: "No validation success orders found", color: grey, weight: FontWeight.w300, size: 22,),
          ],
        )
      ],
    ) :
    ListView.builder(
        itemCount: orderProvider.validationSuccess.length,
        itemBuilder: (_, indexValidationSuccessOrders){
          OrderModel _order = orderProvider.validationSuccess[indexValidationSuccessOrders];
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'User Information'),
                            GestureDetector(
                              onTap: () async{
                                await userProvider.getUserById(id: _order.userId);
                                userInformationModal(_order.id);
                              },
                              child: Text('Click here',
                                style: TextStyle(color: Colors.blueAccent,
                                    decoration: TextDecoration.underline),),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'Order Status'),
                            CustomText(text: _order.status, color: green,)
                          ],
                        ),
                        SizedBox(height: 10,),
                        //PRODUCT LIST
                        Theme(
                          data: ThemeData(accentColor: _onExpansionClicked ? active : noActive,),
                          child: ExpansionTile(
                            onExpansionChanged: (clicked){
                              setState(() {
                                _onExpansionClicked = clicked;
                              });
                            },
                            title: Row(
                              children: <Widget>[
                                Container(
                                  color: blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 40,
                                        width: 80,
                                        child: Center(child: CustomText(text: "${_order.cart.length.toString()}""x", color: white, size: 20,))
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'ID : '),
                                        CustomText(text: _order.id.toUpperCase(), weight: FontWeight.bold,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Desc : '),
                                        CustomText(text: _order.description),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Service : '),
                                        CustomText(text: _order.service),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(
                                        text: 'Message order '),
                                    _order.message.isEmpty
                                        ? CustomText(text: '---')
                                        : CustomText(text: _order.message)
                                  ],
                                ),
                              ),
                              ColumnBuilder(
                                  itemCount: _order.cart.length,
                                  itemBuilder: (_, indexCartProduct){
                                    CartItemModel _cart = _order.cart[indexCartProduct];
                                    return ListTile(
                                      leading: Container(
                                        height: 80,
                                        width: 80,
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: _order.cart[indexCartProduct].imageProduct,
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 140,
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CustomText(text: _cart.nameProduct, weight: FontWeight.bold,),
                                          Visibility(
                                            visible: _cart.nameLens.isNotEmpty,
                                            child: CustomText(
                                                text: _cart.adjustLens.isNotEmpty
                                                    ? '${_cart.nameLens} <with adjust lens>' : _cart.nameLens),
                                          ),
                                        ],
                                      ),
                                      subtitle: CustomText(text: '${formatCurrency.format(_cart.priceProduct)}',),
                                    );
                                  }),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for product', color: grey,),
                                          CustomText(text: '${formatCurrency.format(_order.totalProductPrice)}')
                                        ],
                                      ),
                                      Visibility(
                                        visible: _order.totalLensPrice != 0 ? true : false,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(text: 'Subtotal for custom lens', color: grey),
                                            CustomText(text: '${formatCurrency.format(_order.totalLensPrice)}')
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for shipping ', color: grey),
                                          CustomText(text: '${formatCurrency.format(_order.charges)}'),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        Divider(color: blue),
                        //Amount Payable
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: CustomText(text: '  Total payment '),
                            ),
                            CustomText(text: '${formatCurrency.format(_order.totalPayment)}', weight: FontWeight.bold,)
                          ],
                        ),
                        Divider(color: blue),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(text: 'Order Time              '
                                      '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.orderTime))}',
                                    color: grey,),
                                  Visibility(
                                    visible: _order.paymentTime != 0 ? true : false,
                                    child: CustomText(text: 'Payment Time        '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.paymentTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.shipTime != 0 ? true : false,
                                    child: CustomText(text: 'Ship Time                '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.completedTime != 0 ? true : false,
                                    child: CustomText(text: 'Completed Time    '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                ],
                              ),
                              _order.service == "MyOptik Express"
                                  ? Container(
                                height: 35,
                                child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: blue,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async{
                                        appProvider.changeIsLoading();
                                        bool updateStatus = await orderProvider.updateOrder(
                                          orderId: _order.id, status: 'Delivery',);
                                        if(updateStatus){
                                          _key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: white,
                                              content: Text("Order has been delivery",
                                                  style: TextStyle(
                                                      color: blue))));
                                          orderProvider.getValidationSuccessOrder();
                                          orderProvider.getDeliveryOrder();
                                          appProvider.changeIsLoading();
                                          Future.delayed(Duration(milliseconds: 500),(){
                                            _controller.animateTo(_controller.index +2, duration: Duration(milliseconds: 500));
                                          });
                                        }else{
                                          _key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: white,
                                              content: Text("Update failed",
                                                  style: TextStyle(
                                                      color: blue))));
                                          appProvider.changeIsLoading();
                                        }
                                      },
                                      child: CustomText(text: 'Delivery', color: white,),
                                    )
                                ),
                              ) : Container(
                                height: 35,
                                child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: blue,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async{
                                        appProvider.changeIsLoading();
                                        bool updateStatus = await orderProvider.updateOrder(
                                          orderId: _order.id, status: 'Ready to pick up',);
                                        if(updateStatus){
                                          _key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: white,
                                              content: Text("Order already to pick up",
                                                  style: TextStyle(
                                                      color: blue))));
                                          orderProvider.getValidationSuccessOrder();
                                          orderProvider.getReadyToPickUp();
                                          appProvider.changeIsLoading();
                                          Future.delayed(Duration(milliseconds: 500),(){
                                            _controller.animateTo(_controller.index +1, duration: Duration(milliseconds: 500));
                                          });
                                        }else{
                                          _key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: white,
                                              content: Text("Update failed",
                                                  style: TextStyle(
                                                      color: blue))));
                                          appProvider.changeIsLoading();
                                        }
                                      },
                                      child: CustomText(text: 'Ready', color: white,),
                                    )
                                ),
                              )
                            ]
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }
  Widget readyToPickUpOrder(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return orderProvider.readyToPickUp.length == 0 ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shopping_basket_outlined, color: grey, size: 30,),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(text: "No ready to pick up orders found", color: grey, weight: FontWeight.w300, size: 22,),
          ],
        )
      ],
    ) :
    ListView.builder(
        itemCount: orderProvider.readyToPickUp.length,
        itemBuilder: (_, indexReadyToPickUpOrders){
          OrderModel _order = orderProvider.readyToPickUp[indexReadyToPickUpOrders];
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'User Information'),
                            GestureDetector(
                              onTap: () async{
                                await userProvider.getUserById(id: _order.userId);
                                userInformationModal(_order.id);
                              },
                              child: Text('Click here',
                                style: TextStyle(color: Colors.blueAccent,
                                    decoration: TextDecoration.underline),),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'Order Status'),
                            CustomText(text: _order.status, color: yellow,)
                          ],
                        ),
                        SizedBox(height: 10,),
                        //PRODUCT LIST
                        Theme(
                          data: ThemeData(accentColor: _onExpansionClicked ? active : noActive,),
                          child: ExpansionTile(
                            onExpansionChanged: (clicked){
                              setState(() {
                                _onExpansionClicked = clicked;
                              });
                            },
                            title: Row(
                              children: <Widget>[
                                Container(
                                  color: blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 40,
                                        width: 80,
                                        child: Center(child: CustomText(text: "${_order.cart.length.toString()}""x", color: white, size: 20,))
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'ID : '),
                                        CustomText(text: _order.id.toUpperCase(), weight: FontWeight.bold,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Desc : '),
                                        CustomText(text: _order.description),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Service : '),
                                        CustomText(text: _order.service),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(
                                        text: 'Message order '),
                                    _order.message.isEmpty
                                        ? CustomText(text: '---')
                                        : CustomText(text: _order.message)
                                  ],
                                ),
                              ),
                              ColumnBuilder(
                                  itemCount: _order.cart.length,
                                  itemBuilder: (_, indexCartProduct){
                                    CartItemModel _cart = _order.cart[indexCartProduct];
                                    return ListTile(
                                      leading: Container(
                                        height: 80,
                                        width: 80,
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: _order.cart[indexCartProduct].imageProduct,
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 140,
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CustomText(text: _cart.nameProduct, weight: FontWeight.bold,),
                                          Visibility(
                                            visible: _cart.nameLens.isNotEmpty,
                                            child: CustomText(
                                                text: _cart.adjustLens.isNotEmpty
                                                    ? '${_cart.nameLens} <with adjust lens>' : _cart.nameLens),
                                          ),
                                        ],
                                      ),
                                      subtitle: CustomText(text: '${formatCurrency.format(_cart.priceProduct)}',),
                                    );
                                  }),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for product', color: grey,),
                                          CustomText(text: '${formatCurrency.format(_order.totalProductPrice)}')
                                        ],
                                      ),
                                      Visibility(
                                        visible: _order.totalLensPrice != 0 ? true : false,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(text: 'Subtotal for custom lens', color: grey),
                                            CustomText(text: '${formatCurrency.format(_order.totalLensPrice)}')
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for shipping ', color: grey),
                                          CustomText(text: '${formatCurrency.format(_order.charges)}'),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        Divider(color: blue),
                        //Amount Payable
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: CustomText(text: '  Total payment '),
                            ),
                            CustomText(text: '${formatCurrency.format(_order.totalPayment)}', weight: FontWeight.bold,)
                          ],
                        ),
                        Divider(color: blue),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(text: 'Order Time              '
                                      '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.orderTime))}',
                                    color: grey,),
                                  Visibility(
                                    visible: _order.paymentTime != 0 ? true : false,
                                    child: CustomText(text: 'Payment Time        '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.paymentTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.shipTime != 0 ? true : false,
                                    child: CustomText(text: 'Ship Time                '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.completedTime != 0 ? true : false,
                                    child: CustomText(text: 'Completed Time    '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                ],
                              ),
                              Container(
                                height: 35,
                                child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: blue,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async{
                                        appProvider.changeIsLoading();
                                        bool updateStatus = await orderProvider.updateOrder(
                                          orderId: _order.id, status: 'Completed',);
                                        if(updateStatus){
                                          _key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: white,
                                              content: Text("Order has been completed",
                                                  style: TextStyle(
                                                      color: blue))));
                                          orderProvider.getReadyToPickUp();
                                          orderProvider.getCompletedOrder();
                                          appProvider.changeIsLoading();
                                          Future.delayed(Duration(milliseconds: 500),(){
                                            _controller.animateTo(_controller.index +2, duration: Duration(milliseconds: 500));
                                          });
                                        }else{
                                          _key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: white,
                                              content: Text("Update failed",
                                                  style: TextStyle(
                                                      color: blue))));
                                          appProvider.changeIsLoading();
                                        }
                                      },
                                      child: CustomText(text: 'Completed', color: white,),
                                    )
                                ),
                              )
                            ]
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }
  Widget deliveryOrder(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return orderProvider.deliveryOrders.length == 0 ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shopping_basket_outlined, color: grey, size: 30,),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(text: "No delivery orders found", color: grey, weight: FontWeight.w300, size: 22,),
          ],
        )
      ],
    ) :
    ListView.builder(
        itemCount: orderProvider.deliveryOrders.length,
        itemBuilder: (_, indexDeliveryOrders){
          OrderModel _order = orderProvider.deliveryOrders[indexDeliveryOrders];
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'User Information'),
                            GestureDetector(
                              onTap: () async{
                                await userProvider.getUserById(id: _order.userId);
                                userInformationModal(_order.id);
                              },
                              child: Text('Click here',
                                style: TextStyle(color: Colors.blueAccent,
                                    decoration: TextDecoration.underline),),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'Order Status'),
                            CustomText(text: _order.status, color: yellow,)
                          ],
                        ),
                        SizedBox(height: 10,),
                        //PRODUCT LIST
                        Theme(
                          data: ThemeData(accentColor: _onExpansionClicked ? active : noActive,),
                          child: ExpansionTile(
                            onExpansionChanged: (clicked){
                              setState(() {
                                _onExpansionClicked = clicked;
                              });
                            },
                            title: Row(
                              children: <Widget>[
                                Container(
                                  color: blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 40,
                                        width: 80,
                                        child: Center(child: CustomText(text: "${_order.cart.length.toString()}""x", color: white, size: 20,))
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'ID : '),
                                        CustomText(text: _order.id.toUpperCase(), weight: FontWeight.bold,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Desc : '),
                                        CustomText(text: _order.description),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Service : '),
                                        CustomText(text: _order.service),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(
                                        text: 'Message order '),
                                    _order.message.isEmpty
                                        ? CustomText(text: '---')
                                        : CustomText(text: _order.message)
                                  ],
                                ),
                              ),
                              ColumnBuilder(
                                  itemCount: _order.cart.length,
                                  itemBuilder: (_, indexCartProduct){
                                    CartItemModel _cart = _order.cart[indexCartProduct];
                                    return ListTile(
                                      leading: Container(
                                        height: 80,
                                        width: 80,
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: _order.cart[indexCartProduct].imageProduct,
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 140,
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CustomText(text: _cart.nameProduct, weight: FontWeight.bold,),
                                          Visibility(
                                            visible: _cart.nameLens.isNotEmpty,
                                            child: CustomText(
                                                text: _cart.adjustLens.isNotEmpty
                                                    ? '${_cart.nameLens} <with adjust lens>' : _cart.nameLens),
                                          ),
                                        ],
                                      ),
                                      subtitle: CustomText(text: '${formatCurrency.format(_cart.priceProduct)}',),
                                    );
                                  }),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for product', color: grey,),
                                          CustomText(text: '${formatCurrency.format(_order.totalProductPrice)}')
                                        ],
                                      ),
                                      Visibility(
                                        visible: _order.totalLensPrice != 0 ? true : false,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(text: 'Subtotal for custom lens', color: grey),
                                            CustomText(text: '${formatCurrency.format(_order.totalLensPrice)}')
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for shipping ', color: grey),
                                          CustomText(text: '${formatCurrency.format(_order.charges)}'),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        Divider(color: blue),
                        //Amount Payable
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: CustomText(text: '  Total payment '),
                            ),
                            CustomText(text: '${formatCurrency.format(_order.totalPayment)}', weight: FontWeight.bold,)
                          ],
                        ),
                        Divider(color: blue),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(text: 'Order Time              '
                                      '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.orderTime))}',
                                    color: grey,),
                                  Visibility(
                                    visible: _order.paymentTime != 0 ? true : false,
                                    child: CustomText(text: 'Payment Time        '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.paymentTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.shipTime != 0 ? true : false,
                                    child: CustomText(text: 'Ship Time                '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.completedTime != 0 ? true : false,
                                    child: CustomText(text: 'Completed Time    '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                ],
                              ),
                              Container(
                                height: 35,
                                child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: blue,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async{
                                        appProvider.changeIsLoading();
                                        bool updateStatus = await orderProvider.updateOrder(
                                          orderId: _order.id, status: 'Completed',);
                                        if(updateStatus){
                                          _key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: white,
                                              content: Text("Order has been completed",
                                                  style: TextStyle(
                                                      color: blue))));
                                          orderProvider.getDeliveryOrder();
                                          orderProvider.getCompletedOrder();
                                          appProvider.changeIsLoading();
                                          Future.delayed(Duration(milliseconds: 500),(){
                                            _controller.animateTo(_controller.index +1, duration: Duration(milliseconds: 500));
                                          });
                                        }else{
                                          _key.currentState.showSnackBar(SnackBar(
                                              backgroundColor: white,
                                              content: Text("Update failed",
                                                  style: TextStyle(
                                                      color: blue))));
                                          appProvider.changeIsLoading();
                                        }
                                      },
                                      child: CustomText(text: 'Completed', color: white,),
                                    )
                                ),
                              )
                            ]
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }
  Widget completedOrder(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return orderProvider.completedOrders.length == 0 ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shopping_basket_outlined, color: grey, size: 30,),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(text: "No completed orders found", color: grey, weight: FontWeight.w300, size: 22,),
          ],
        )
      ],
    ) :
    ListView.builder(
        itemCount: orderProvider.completedOrders.length,
        itemBuilder: (_, indexCompletedOrders){
          OrderModel _order = orderProvider.completedOrders[indexCompletedOrders];
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'User Information'),
                            GestureDetector(
                              onTap: () async{
                                await userProvider.getUserById(id: _order.userId);
                                userInformationModal(_order.id);
                              },
                              child: Text('Click here',
                                style: TextStyle(color: Colors.blueAccent,
                                    decoration: TextDecoration.underline),),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'Order Status'),
                            CustomText(text: _order.status, color: green)
                          ],
                        ),
                        SizedBox(height: 10,),
                        //PRODUCT LIST
                        Theme(
                          data: ThemeData(accentColor: _onExpansionClicked ? active : noActive,),
                          child: ExpansionTile(
                            onExpansionChanged: (clicked){
                              setState(() {
                                _onExpansionClicked = clicked;
                              });
                            },
                            title: Row(
                              children: <Widget>[
                                Container(
                                  color: blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 40,
                                        width: 80,
                                        child: Center(child: CustomText(text: "${_order.cart.length.toString()}""x", color: white, size: 20,))
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'ID : '),
                                        CustomText(text: _order.id.toUpperCase(), weight: FontWeight.bold,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Desc : '),
                                        CustomText(text: _order.description),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        CustomText(text: 'Service : '),
                                        CustomText(text: _order.service),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(
                                        text: 'Message order '),
                                    _order.message.isEmpty
                                        ? CustomText(text: '---')
                                        : CustomText(text: _order.message)
                                  ],
                                ),
                              ),
                              ColumnBuilder(
                                  itemCount: _order.cart.length,
                                  itemBuilder: (_, indexCartProduct){
                                    CartItemModel _cart = _order.cart[indexCartProduct];
                                    return ListTile(
                                      leading: Container(
                                        height: 80,
                                        width: 80,
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: _order.cart[indexCartProduct].imageProduct,
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 140,
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CustomText(text: _cart.nameProduct, weight: FontWeight.bold,),
                                          Visibility(
                                            visible: _cart.nameLens.isNotEmpty,
                                            child: CustomText(
                                                text: _cart.adjustLens.isNotEmpty
                                                    ? '${_cart.nameLens} <with adjust lens>' : _cart.nameLens),
                                          ),
                                        ],
                                      ),
                                      subtitle: CustomText(text: '${formatCurrency.format(_cart.priceProduct)}',),
                                    );
                                  }),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for product', color: grey,),
                                          CustomText(text: '${formatCurrency.format(_order.totalProductPrice)}')
                                        ],
                                      ),
                                      Visibility(
                                        visible: _order.totalLensPrice != 0 ? true : false,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CustomText(text: 'Subtotal for custom lens', color: grey),
                                            CustomText(text: '${formatCurrency.format(_order.totalLensPrice)}')
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CustomText(text: 'Subtotal for shipping ', color: grey),
                                          CustomText(text: '${formatCurrency.format(_order.charges)}'),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        Divider(color: blue),
                        //Amount Payable
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: CustomText(text: '  Total payment '),
                            ),
                            CustomText(text: '${formatCurrency.format(_order.totalPayment)}', weight: FontWeight.bold,)
                          ],
                        ),
                        Divider(color: blue),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(text: 'Order Time              '
                                      '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.orderTime))}',
                                    color: grey,),
                                  Visibility(
                                    visible: _order.paymentTime != 0 ? true : false,
                                    child: CustomText(text: 'Payment Time        '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.paymentTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.shipTime != 0 ? true : false,
                                    child: CustomText(text: 'Ship Time                '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                  Visibility(
                                    visible: _order.completedTime != 0 ? true : false,
                                    child: CustomText(text: 'Completed Time    '
                                        '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                      color: grey,),
                                  ),
                                ],
                              ),
                              Container(
                                height: 35,
                                child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: blue,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async{
                                        appProvider.changeIsLoading();
                                        await userProvider.getUserById(id: _order.userId);
                                        changeScreen(context,
                                            DetailOrder(order: _order, orderCart: _order.cart[indexCompletedOrders],));
                                        appProvider.changeIsLoading();
                                      },
                                      child: CustomText(text: 'Detail Order', color: white,),
                                    )
                                ),
                              )
                            ]
                        ),
                      ],
                    )
                ),
              ),
            ),
          );
        });
  }

  void userInformationModal(orderId){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var modal = Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person_outline, color: blue, size: 25,),
                    CustomText(text: 'User Information', weight: FontWeight.bold, size: 18,),
                  ],
                ),
              ),
              SizedBox(height: 2,),
              Divider(thickness: 3, color: blue,),
              SizedBox(height: 2,),
              Divider(color: grey,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomText(text: 'Order ID ',),
                  CustomText(text: orderId.toString().toUpperCase(), weight: FontWeight.bold,),
                ],
              ),
              Divider(color: grey,),
              SizedBox(height: 2,),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CustomText(text: 'Name'),
                              CustomText(text: userProvider.userModel.name),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CustomText(text: 'Phone'),
                              CustomText(text: '(+${userProvider.userModel.phone.toString()})'),
                            ],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(text: 'Address : '),
                                SizedBox(height: 5,),
                                CustomText(text: userProvider.userModel.address),
                              ]
                          ),
                        ]
                    )
                ),
              ),
            ]
        ),
      ),
    );
    showBarModalBottomSheet(
        barrierColor: black.withOpacity(0.5),
        backgroundColor: black.withOpacity(0.1),
        context: context,
        builder: (_) => modal);
  }
}
