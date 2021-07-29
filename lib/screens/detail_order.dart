import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/common.dart';
import 'package:lets_shop_admin/component/column_builder.dart';
import 'package:lets_shop_admin/component/custom_text.dart';
import 'package:lets_shop_admin/component/expand_image_file.dart';
import 'package:lets_shop_admin/component/expand_image_network.dart';
import 'package:lets_shop_admin/component/expandable_text.dart';
import 'package:lets_shop_admin/models/cart_item.dart';
import 'package:lets_shop_admin/models/order.dart';
import 'package:lets_shop_admin/provider/app_provider.dart';
import 'package:lets_shop_admin/provider/order_provider.dart';
import 'package:lets_shop_admin/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailOrder extends StatefulWidget {
  final OrderModel order;
  final CartItemModel orderCart;

  const DetailOrder({Key key, this.order, this.orderCart}) : super(key: key);
  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  DateFormat dateFormat;

  final _key = GlobalKey<ScaffoldState>();

  bool _loading = false;
  bool _hideNotiClicked = false;

  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMd('id_ID').add_Hm();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: white,
        title: CustomText(
            text: 'Detail Order',
            size: 23, color: blue,
            weight: FontWeight.bold),
        centerTitle: true,
        leading: InkWell(
            child : Icon(Icons.arrow_back_ios, color: blue,),
            onTap: () async{
              Navigator.pop(context);
            }
        ),
      ),
      body: Container(
        color: grey.withOpacity(0.1),
        child: ListView(
            children: <Widget>[
              Visibility(
                  visible: widget.order.status == "Pending validation" ? true : false,
                  child: attention()),
              Container(
                height: 56,
                color: white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(text: 'Order Status'),
                          CustomText(
                            text: widget.order.status,
                            color: widget.order.status == "Pending validation" ? redAccent : green,
                            weight: FontWeight.bold,),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(text: 'Total Payment'),
                          CustomText(text: '${formatCurrency.format(widget.order.totalPayment)}', color: blue, weight: FontWeight.bold,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: widget.order.status == "Pending validation" ? true : false,
                  child: SizedBox(height: 10,)),
              Visibility(
                  visible: widget.order.status == "Pending validation" ? true : false,
                  child: validateOrder()
              ),
              SizedBox(height: 10,),
              detailOrder(),
              SizedBox(height: 10,),
              userInformation()
            ]
        ),
      ),
    );
  }

  Widget userInformation(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5,),
              Row(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topCenter,
                      height: 20,
                      width: 40,
                      child: Icon(Icons.person_outline, color: blue, size: 22,)
                  ),
                  SizedBox(width: 10,),
                  CustomText(text: 'User information'),
                ],
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(color: grey,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          ],
                        ),
                      ],
                    ),
                    Divider(color: grey,),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }

  Widget validateOrder(){
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5,),
                  Icon(
                    Icons.payments_outlined ,
                    color: blue,
                    size: 22,),
                  SizedBox(width: 15,),
                  CustomText(text: 'Proof of Payment ',),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 8, 8),
              child: Container(
                child: Column(
                    children: <Widget>[
                      Divider(color: grey,),
                      SizedBox(height: 10,),
                      DottedBorder(
                          dashPattern: [8,4],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10),
                          color: blue,
                          child: GestureDetector(
                            onTap: (){
                              changeScreen(context, ExpandImageNetwork(
                                imageUrl: widget.order.imgUrlPayment,
                                enableSlideOutPage: true,)
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              height: 300,
                              width: 400,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: widget.order.imgUrlPayment,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                      ),
                      SizedBox(height: 10,),
                      Divider(color: grey,),
                      SizedBox(height: 10,),
                      Container(
                        height: 40,
                        width: 400,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: blue,
                                  elevation: 0.0,
                                  child: MaterialButton(
                                    onPressed: ()async{
                                      appProvider.changeIsLoading();
                                      bool updateStatus = await orderProvider.updateOrder(
                                        orderId: widget.order.id, status: 'Validation success');
                                      if(updateStatus){
                                        _key.currentState.showSnackBar(SnackBar(
                                            backgroundColor: white,
                                            content: Text("Order has been accepted",
                                                style: TextStyle(
                                                    color: blue))));
                                        bool deleteImage = await orderProvider.deleteImage(imageRef: widget.order.imgRef);
                                        if(deleteImage){
                                          print('delete image success');
                                        }else{
                                          print('delete image failed');
                                        }
                                        orderProvider.getPendingOrder();
                                        orderProvider.getValidationSuccessOrder();
                                        Navigator.pop(context);
                                        appProvider.changeIsLoading();
                                      }else{
                                        _key.currentState.showSnackBar(SnackBar(
                                            backgroundColor: white,
                                            content: Text("Update failed",
                                                style: TextStyle(
                                                    color: blue))));
                                        appProvider.changeIsLoading();
                                      }
                                    },
                                    child: CustomText(text: 'Accept Order', color: white,),
                                  )
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: blue,
                                  elevation: 0.0,
                                  child: MaterialButton(
                                    onPressed: ()async{
                                      appProvider.changeIsLoading();
                                      bool updateStatus = await orderProvider.updateOrder(
                                          orderId: widget.order.id, status: 'Incomplete');
                                      if(updateStatus){
                                        _key.currentState.showSnackBar(SnackBar(
                                            backgroundColor: white,
                                            content: Text("Order has been rejected",
                                                style: TextStyle(
                                                    color: blue))));
                                        bool deleteImage = await orderProvider.deleteImage(imageRef: widget.order.imgRef);
                                        if(deleteImage){
                                          print('delete image success');
                                        }else{
                                          print('delete image failed');
                                        }
                                        orderProvider.getPendingOrder();
                                        orderProvider.getIncompleteOrder();
                                        Navigator.pop(context);
                                        appProvider.changeIsLoading();
                                      }else{
                                        _key.currentState.showSnackBar(SnackBar(
                                            backgroundColor: white,
                                            content: Text("Update failed",
                                                style: TextStyle(
                                                    color: blue))));
                                        appProvider.changeIsLoading();
                                      }
                                    },
                                    child: CustomText(text: 'Reject Order', color: white,),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailOrder(){
    return Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5,),
            Row(
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    height: 20,
                    width: 40,
                    child: Icon(Icons.shopping_basket_outlined, color: blue, size: 22,)
                ),
                SizedBox(width: 10,),
                CustomText(text: 'Order Item'),
              ],
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(color: grey,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(text: 'ID '),
                          CustomText(text: widget.order.id.toUpperCase(), weight: FontWeight.bold,),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(text: 'Desc'),
                          CustomText(text: widget.order.description),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(text: 'Service'),
                          CustomText(text: widget.order.service),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(
                              text: 'Message order '),
                          widget.order.message.isEmpty
                              ? CustomText(text: '---')
                              : CustomText(text: widget.order.message, size: 14,)
                        ],
                      ),
                    ],
                  ),
                  Divider(color: grey,),
                  ColumnBuilder(
                      itemCount: widget.order.cart.length,
                      itemBuilder: (_, indexCartProduct){
                        CartItemModel _cart = widget.order.cart[indexCartProduct];
                        return ListTile(
                          leading: Container(
                            height: 80,
                            width: 80,
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: widget.order.cart[indexCartProduct].imageProduct,
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
                                  visible: _cart.nameLens != "",
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CustomText(
                                          text: _cart.adjustLens.isNotEmpty
                                              ? '${_cart.nameLens} <with adjust lens>' : _cart.nameLens, size: 14, weight: FontWeight.bold,),
                                      Visibility(
                                        visible: _cart.adjustLens.isNotEmpty,
                                        child: CustomText(text:'${_cart.adjustLens}',
                                          size: 12,),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                          subtitle: CustomText(text: '${formatCurrency.format(_cart.priceProduct)}',),
                        );
                      }
                  ),
                  Divider(color: grey,),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(text: 'Subtotal for product', color: grey,),
                          CustomText(text: '${formatCurrency.format(widget.order.totalProductPrice)}')
                        ],
                      ),
                      Visibility(
                        visible: widget.order.totalLensPrice != 0 ? true : false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomText(text: 'Subtotal for custom lens', color: grey),
                            CustomText(text: '${formatCurrency.format(widget.order.totalLensPrice)}')
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomText(text: 'Subtotal for shipping ', color: grey),
                          CustomText(text: '${formatCurrency.format(widget.order.charges)}'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget attention(){
    return GestureDetector(
      onTap: (){
        setState(() {
          _hideNotiClicked = true;
        });
      },
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: _hideNotiClicked ? 0 : 100,
            color: yellow.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.only(left: 8,bottom: 50, right: 5),
              child: Icon(Icons.notifications_active_outlined),
            ),
          ),
          Expanded(
            child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: _hideNotiClicked ? 0 : 100,
                color: yellow.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: CustomText(
                    text: 'Please check carefully. whether the buyer has attached proof of transfer correctly or not. '
                        'then check the Admin account, whether the transfer amount is in accordance with the evidence '
                        'attached by the buyer.',
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

}
