import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mokkon_cards/model/cardModel/biz_card.dart';
import 'package:mokkon_cards/model/userModel/user.dart';
//import 'package:mokkon_cards/widgets/signup.dart' as prefix0;

/// these interface implements user auth for all models
class ImplementInterfaceModel {
  void init(User user) => {};
}
typedef void CodeSentCallback();
typedef void FailedCallback(AuthException a);
typedef void CompleteCallback();
typedef void LoginCallback(List<BizCard> bizCards);
typedef void FailedVerifedCallback(PlatformException e);

class UserAuth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  FirebaseUser _firebaseUser;
  List<ImplementInterfaceModel> imnModels = [];

  User usr;
  bool isHas = false;
  int currentCardPoint;
  UserAuth() {
    loadUser();
  }
  bool isLogin() {
    if (usr != null && _firebaseUser != null) {
      return true;
    }
    return false;
  }

  bool isSignup() {
    return this.usr != null;
  }

  void loadUser() async {
    await _load();
  }

  void logout() {
    if (isLogin()) {
      _auth.signOut();
      _firebaseUser = null;
      usr = null;
      notifyListeners();
    }
  }

  void addModel(ImplementInterfaceModel model) {
    imnModels.add(model);
  }

  initModel() {
    if (this.usr == null || this._firebaseUser == null) return;
    imnModels.forEach((m) => m.init(this.usr));
  }

  Future<FirebaseUser> getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return await _auth.currentUser();
  }

  String get phone {
    if (_firebaseUser != null &&
        _firebaseUser.providerData != null &&
        _firebaseUser.providerData.length > 0)
      return _firebaseUser.providerData[0].phoneNumber;
    else
      return "unknown";
  }

  Future<void> sendCodeToPhoneNumber(String phoneNumber,
      CodeSentCallback codeSentCallback, FailedCallback failedCallback,
      {CompleteCallback complete}) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential user) {
      complete();
      print(
          'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      failedCallback(authException);
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      print("code sent to " + phoneNumber);
      codeSentCallback();
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      print("time out");
    };

    return FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void signInWithPhoneNumber(String smsCode, CompleteCallback complete,
      FailedVerifedCallback failCallback) async {
    FirebaseUser _fusr;
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    try {
      _fusr = await _auth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      failCallback(e);
      return;
    }
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(_fusr.uid == currentUser.uid);
    print("sing up with phone number $_fusr");
    complete();
    await _load();
    notifyListeners();
  }

  int time = 0;
  Future<User> signUp(User signupUser) async {
    User _usr;
    final DocumentReference docUser =
        Firestore.instance.collection('customers').document(_firebaseUser.uid);
    User _user = User(
        id: _firebaseUser.uid,
        name: signupUser.name,
        phoneNumber: _firebaseUser.phoneNumber,
        dateofBirth: signupUser.dateofBirth,
        gender: signupUser.gender);
    await Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(docUser, _user.toMap());
    });
    time = 0;
    _usr = await _continueLoad();
    return _usr;
  }

  Future<User> _continueLoad() async {
    await Future.delayed(
        const Duration(seconds: 3), () async => {await _load()});
    time += 3;
    if (time > 10) {
      return null;
    }
    if (!isSignup()) {
      await _continueLoad();
    }
    return usr;
  }

  Future<User> getUserFromFirebaseByPhoneNumber(String phone) async {
    List<User> _userList = [];
    var getuser = await Firestore.instance
        .collection('customers')
        .where("phoneNumber", isEqualTo: phone.toLowerCase())
        .getDocuments();
    getuser.documents.forEach((doc) {
      var u = User.fromMap(doc.data);
      _userList.add(u);
    });
    if (_userList.length > 0) {
      this.usr = _userList.first;
      isHas = true;
      return _userList.first;
    }
    return null;
  }
  void signOut() {
    if (_firebaseUser == null) return;
    FirebaseAuth.instance.signOut();
    _firebaseUser = null;
    notifyListeners();
  }

  _load() async {
    _firebaseUser = await _auth.currentUser();
    User _user = await _getUser();
    this.usr = _user;
    initModel();
    print("Load User:${this.usr}");
    notifyListeners();
  }
  Future<User> _getUser() async {
    User _user;
    // get user
    if (_firebaseUser == null) return null;
    try {
      DocumentSnapshot snapshot = await Firestore.instance
          .collection('customers')
          .document(_firebaseUser.uid)
          .get();
      if (!snapshot.exists) {
        return null;
      }
      _user = User.fromMap(snapshot.data);
    } catch (e) {
      // permission error
      print("user error:" + e.toString());
      return null;
    }
    return _user;
  }
}
