import 'package:flutter/material.dart';
import 'package:lets_shop_admin/commons/color.dart';
import 'package:lets_shop_admin/commons/loading.dart';
import 'package:lets_shop_admin/component/custom_text.dart';


class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            Container(
              height: 200,
              width: 200,
              margin: EdgeInsets.only(bottom:5),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/nointernet.png")
                  )
              ),
            ),
            CustomText(
              text: "No Internet Connection",
              size: 25,
              weight: FontWeight.bold,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: CustomText(text: "\t You are not connected to the internet. Make sure\n"
                    "Wi-Fi or Mobile Data is on, and Airplane mode is off.",
                  size: 16,
                ),
              ),
            ),
            SizedBox(height: 150),
            Center(child: Loading()),
          ],
        ),
      ),
    );
  }
}
