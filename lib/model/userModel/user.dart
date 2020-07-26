
import 'package:mokkon_cards/model/cardModel/biz_card.dart';

class User {
  final String id;
  final String name;
  final String password;
  final String gender;
  final String phoneNumber;
  final String dateofBirth;
   List<BizCard> bizCard;
  String  get  getid => this.id;
  String  get  getname => this.name;
  String  get  getpassword => this.password;
  String get getphonenumber => this.phoneNumber;
  String get getdateofBirth => this.dateofBirth;

 

  User({this.name,this.password, this.phoneNumber,this.dateofBirth,this.id,this.gender,this.bizCard});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      name:parsedJson['name'],
      password: parsedJson['password'],
      phoneNumber: parsedJson['phoneNumber'],
      dateofBirth:parsedJson['dateofBirth'],
      id:parsedJson['id'],
      gender: parsedJson['gender'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name':name,
        'password': password,
        'phoneNumber': phoneNumber,
        'dateofBirth':dateofBirth,
        'id':id,
        'gender':gender
      };
    Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
      'dateofBirth':dateofBirth ,
      'id':id,
      'gender':gender
    };
  }
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
    name: map['name'],
    password :map['password'],
    phoneNumber: map['phoneNumber'],
    dateofBirth:map['dateofBirth'],
    id:map['id'],
    gender: map['gender']
    );
  }
  @override
  String toString() {
    return 'User{name: $name, password: $password, phoneNumber: $phoneNumber,dateofBirth:$dateofBirth,id:$id,gender:$gender,bizCard:$bizCard}';
  }
}
