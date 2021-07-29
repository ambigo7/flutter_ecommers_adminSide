import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop_admin/models/user.dart';
import 'package:lets_shop_admin/service/user.dart';

class UserProvider with ChangeNotifier{

  UserService _userService = UserService();

  UserModel _userModel;
  UserModel get userModel => _userModel;

  int countUser;

  UserProvider.initialize(){
    getCountUsers();
  }

  Future<void> getUserById({@required String id}) async{
    _userModel = await _userService.getUserById(id);
    print("test Get user by id ${_userModel.email}: ${userModel.address}");
    print("test Get user by id ${_userModel.email}: ${userModel.phone}");
    notifyListeners();
  }

  getCountUsers() async {
    List<DocumentSnapshot> data = await _userService.getUsers();
    print('Users ${data.length}');
    countUser = data.length;
    notifyListeners();
  }
}