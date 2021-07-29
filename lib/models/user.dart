import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel{
  static const ID = 'uid';
  static const NAME = 'name';
  static const EMAIL = 'email';
  static const ADDRESS = 'address';
  static const PHONE = 'phone';

// Private Variabel
  String _id;
  String _name;
  String _email;
  String _address;
  int _phone;

  //Getter read only, private variabel
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get address => _address;
  int get phone => _phone;


  //Contructure data from DB
  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data()[ID];
    _name = snapshot.data()[NAME];
    _email = snapshot.data()[EMAIL];
    _address = snapshot.data()[ADDRESS] ?? "";
    _phone = snapshot.data()[PHONE] ?? 0;
  }
}