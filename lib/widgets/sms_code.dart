import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mokkon_cards/model/auth.dart';
import 'package:mokkon_cards/theme/theme.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
@override
smsCode(BuildContext context, CompleteCallback completeCallback) {
  return showDialog(
    context: context,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Center(
              child: Text(
            'Enter SMS Code',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          )),
          content: pinInput(context, completeCallback),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: mCardColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      );
    },
  );
}
@override
pinInput(BuildContext context, CompleteCallback completeCallback) {
  TextEditingController controller = TextEditingController();
  var userAuth=Provider.of<UserAuth>(context);
  String thisText = "";
  int pinLength = 6;
  bool hasError = false;
  String errorMessage;
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PinCodeTextField(
            pinBoxHeight: 20.0,
            pinBoxWidth: 30.0,
            autofocus: false,
            controller: controller,
            hideCharacter: true,
            highlight: true,
            highlightColor: Colors.black87,
            defaultBorderColor: mCardColor,
            hasTextBorderColor: mCardColor,
            maxLength: pinLength,
            hasError: hasError,
            maskCharacter: "🌑",
            onTextChanged: (text) {
              // setState(() {
              //   hasError = false;
              // });
            },
            onDone: (text) {
              userAuth.signInWithPhoneNumber(text, completeCallback, (e) {
                showMsgDialog(context, 'Error', '$e');
              });
              print("DONE $text");
              Navigator.pushNamed(context, '/');
            },
            pinCodeTextFieldLayoutType:
                PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
            wrapAlignment: WrapAlignment.start,
            pinBoxDecoration:
                ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
            pinTextStyle: TextStyle(fontSize: 30.0),
            pinTextAnimatedSwitcherTransition:
                ProvidedPinBoxTextAnimation.scalingTransition,
            pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
          ),
          Visibility(
            child: Text(
              "Wrong PIN!",
              style: TextStyle(color: Colors.red),
            ),
            visible: hasError,
          ),
        ],
      ),
    ),
  );
}

@override
void showMsgDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(msg),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              if (title == 'success') {
                Navigator.pushNamed(context, '/home');
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
