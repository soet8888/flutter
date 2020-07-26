import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:mokkon_cards/model/auth.dart';
import 'package:mokkon_cards/model/cardModel/biz_card.dart';
import 'userModel/user.dart';

class BizModel extends foundation.ChangeNotifier
    implements ImplementInterfaceModel {
  List<Biz> bizs = [];
  User _user;
  @override
  void init(User user) {
    this._user = user;
    _load();
  }
  void _load() async {
    this.bizs = await _getBizs();
    print("loading Bizs:$bizs");
  }
  Future<List<Biz>> _getBizs() async {
    List<Biz> _biz = new List();
    if (_user == null) return null;
    var bizs = await Firestore.instance.collection('bizs').getDocuments();
    bizs.documents.forEach((doc) {
      var b = Biz.fromMap(doc.data);
      b.docID = doc.documentID;
      _biz.add(b);
    });
    return _biz;
  }
}
