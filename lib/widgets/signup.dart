import 'package:flutter/material.dart';
import 'package:mokkon_cards/main.dart';
import 'package:mokkon_cards/model/auth.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../model/userModel/user.dart';
import '../theme/theme.dart';
import '../widgets/sms_code.dart';

User user = User();

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  int radioValue = 0;
  String selectedRadioValue = 'Male';
  var userAuth;
  void _signUp(BuildContext context) async {
    var uuid = new Uuid();
    var user = await userAuth.signUp(User(
      id: uuid.v4(),
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      dateofBirth: _dobController.text,
      gender: selectedRadioValue,
    ));
    if (user!=null){
      showMsgDialog(context, "success", '${user.name} has been created');
    }
  }
  @override
  Widget build(BuildContext context) {
    userAuth=Provider.of<UserAuth>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: mCardColor,
        body: Center(child: _buildSignup()),
      ),
    );
  }
  Widget _buildSignup() {
    return new Container(
      width: 300.0,
      height: 300.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Center(
              child: Container(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 120.0,
                ),
                new Text(
                  'Signup',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20.0),
                )
              ],
            ),
          )),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 20.0,
              ),
              Icon(
                Icons.person,
                size: 25.0,
                color: Colors.black,
              ),
              SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal),
                      hintText: '   Enter your name',
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 0.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 20.0,
              ),
              Icon(
                Icons.phone,
                size: 25.0,
                color: Colors.black,
              ),
              SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal),
                      hintText: '   Enter phone number',
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 0.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7.0,
          ),
          // Row(
          //   children: <Widget>[
          //     SizedBox(
          //       width: 20.0,
          //     ),
          //     new Tab(
          //         icon: new Image.asset(
          //       "assets/icons/password.png",
          //       height: 25.0,
          //     )),
          //     SizedBox(
          //       width: 20.0,
          //     ),
          //     Flexible(
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 10.0),
          //         child: TextFormField(
          //           obscureText: true,
          //           controller: _passwordController,
          //           decoration: InputDecoration(
          //             hintStyle: TextStyle(
          //                 fontStyle: FontStyle.italic,
          //                 fontWeight: FontWeight.normal),
          //             hintText: '  Enter password',
          //             contentPadding: new EdgeInsets.symmetric(
          //                 vertical: 7.0, horizontal: 0.0),
          //             border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(5.0)),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 7.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 20.0,
              ),
              Icon(
                Icons.date_range,
                size: 25.0,
                color: Colors.black,
              ),
              SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal),
                      hintText: '  Enter date-of-birth',
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 0.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 20.0,
              ),
              new Tab(
                  icon: new Image.asset(
                "assets/icons/gender.png",
                height: 30.0,
              )),
              SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: new Row(
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      activeColor: mCardColor,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged,
                    ),
                    new Text(
                      'Male',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                    new Radio(
                      value: 1,
                      activeColor: mCardColor,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged,
                    ),
                    new Text(
                      'Female',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3.0,
          ),
          new Row(
            children: <Widget>[
              SizedBox(
                width: 100.0,
              ),
              new RaisedButton(
                onPressed: () {
                  _signUp(context);
                  // var uuid = new Uuid();
                  // var userId = uuid.v4();
                  // user = User(
                  //   id: userId,
                  //   name: _nameController.text,
                  //   phoneNumber: _phoneController.text,
                  //   password: _passwordController.text,
                  //   dateofBirth: _dobController.text,
                  //   gender: selectedRadioValue,
                  // );
                  // userAuth.signUp(user, () {
                  //   userAuth.fbUser = user;
                  //   showMsgDialog(
                  //       context, "success", '${user.name} has been created');
                  // });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: mCardColor,
                child: Text(
                  'signup',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
      switch (radioValue) {
        case 0:
          selectedRadioValue = 'Male';
          break;
        case 1:
          selectedRadioValue = 'Female';
          break;
      }
    });
  }
}
