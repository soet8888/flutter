import 'package:flutter/material.dart';
import 'package:mokkon_cards/model/auth.dart';
import 'package:mokkon_cards/widgets/sms_code.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  var userAuth;
  @override
  Widget build(BuildContext context) {
    userAuth=Provider.of<UserAuth>(context);
    return Scaffold(
      backgroundColor: mCardColor,
      body: Center(child: _buildLogin()),
    );
  }

  Widget _buildLogin() {
    return new Container(
      width: 270.0,
      height: 200.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Center(
              child: Container(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 120.0,
                ),
                new Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0),
                )
              ],
            ),
          )),
          SizedBox(
            height: 25.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              Icon(
                Icons.phone,
                size: 25.0,
                color: Colors.black,
              ),
              SizedBox(
                width: 0.0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal),
                      hintText: '  Enter phone number',
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
          // SizedBox(
          //   height: 20.0,
          // ),
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
          //           controller: _password,
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
            height: 25.0,
          ),
          new Row(
            children: <Widget>[
              SizedBox(
                width: 100.0,
              ),
              new RaisedButton(
                onPressed: () async {
                  userAuth.sendCodeToPhoneNumber(_phoneController.text, () {
                    smsCode(context, () async {
                      var user =
                          await userAuth.getUserFromFirebaseByPhoneNumber(
                              _phoneController.text);
                      if (user != null) {
                        Navigator.pushNamed(context, '/home');
                      } else {
                        Navigator.pushNamed(context, '/signup');
                      }
                    });
                  }, (f) {
                    showMsgDialog(context, 'Error', '$f');
                  }).catchError((onError) {
                    showMsgDialog(context, 'Error', '$onError');
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: mCardColor,
                child: Text(
                  'login',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
              )
            ],
          ),
          // SizedBox(
          //   height: 10.0,
          // ),
          // new Row(
          //   children: <Widget>[
          //     SizedBox(
          //       width: 100.0,
          //     ),
          //     FlatButton(
          //       child: Text(
          //         'Signup',
          //         style: TextStyle(
          //             color: Colors.black,
          //             decoration: TextDecoration.underline,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 15.0),
          //       ),
          //       onPressed: () {
          //         Navigator.pushNamed(context, '/signup');
          //       },
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
