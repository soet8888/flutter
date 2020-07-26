import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:mokkon_cards/model/auth.dart';
import 'package:mokkon_cards/model/cardModel/biz_card.dart';
import 'package:mokkon_cards/model/cardModel/sale.dart';
import 'package:uuid/uuid.dart';
import 'random_digits.dart';
import 'userModel/user.dart';

class BizCardModel extends foundation.ChangeNotifier
    implements ImplementInterfaceModel {
  int currentCardIndex = 0;
  List<Sale> sales = new List();
  List<BizCard> bizCards = new List();
  User _user;
  @override
  void init(User user) {
    this._user = user;
    _listenToFirebase(user.id).listen((_) {
      print("<<<Listen To Firebase>>>");
      _load();
    });
  }

  Stream<QuerySnapshot> _listenToFirebase(String userDocID) {
    Stream<QuerySnapshot> snapshots = Firestore.instance
        .collection('customers')
        .document(userDocID)
        .collection("cards")
        .snapshots();
    return snapshots;
  }

  void _load() async {
    await getCards(_user.id, (cards) async {
      this.bizCards = cards;
      print("Loading BizsCard : $bizCards");
      //await initSaleToFirebase();
      notifyListeners();
    });
  }

  setCurrentCard(int index) {
    this.currentCardIndex = index;
    notifyListeners();
  }

  BizCard getCurrentCard() => this.bizCards[this.currentCardIndex];

  Future<List<Sale>> getSales(
      String userDocumentID, String cardDocumentID, int limit) async {
    List<Sale> _sales = [];
    var sale = await Firestore.instance
        .collection('/customers/$userDocumentID/cards/$cardDocumentID/sales')
        .limit(limit)
        .orderBy('date', descending: true)
        .getDocuments();
    sale.documents.forEach((doc) {
      var _s = Sale.fromMap(doc.data);
      _s.docID = doc.documentID;
      _sales.add(_s);
    });
    return _sales;
  }

  Future<void> getCards(
      String userDocumentID, LoginCallback bizCallBack) async {
    if (_user == null) return null;
    List<BizCard> _bizCards = [];
    int i = 1;
    var cards = await Firestore.instance
        .collection('/customers/$userDocumentID/cards')
        .getDocuments();
    var count = cards.documents.length;
    cards.documents.forEach((doc) async {
      var _sale = await getSales(userDocumentID, doc.documentID, 20);
      var biz = BizCard.fromMap(doc.data);
      biz.docID = doc.documentID;
      biz.sales = _sale;
      _bizCards.add(biz);
      if (i == count) {
        bizCallBack(_bizCards);
      }
      i++;
    });
  }

  void addCard(Biz b, CompleteCallback complete) async {
    var card = BizCard(
      bizName: b.name,
      bizID: b.docID,
      cardNum: RandomDigits.getString(16),
      point: 0,
    );
    await Firestore.instance
        .collection('customers')
        .document(_user.id)
        .collection('cards')
        .document()
        .setData(card.toMap());
    complete();
    notifyListeners();
  }

  Future<void> initSaleToFirebase() async {
    print("ININ SALE TO ${bizCards.length}");
    for (int j = 0; j < bizCards.length; j++) {
      for (int i = 0; i < 2; i++) {
        var time = DateTime.now();
        time = time.add(new Duration(days: 60));
        var _s = Sale(
            userDoc: _user.id,
            cardDoc: bizCards[j].docID,
            amt: RandomDigits.getInteger(4),
            date: time,
            point: 5,
            shop: bizCards[j].bizName);
        print("SALE TRX: $_s");
        await Firestore.instance
            .collection('customers')
            .document(_user.id)
            .collection('cards')
            .document(bizCards[j].docID)
            .collection('sales')
            .document()
            .setData(_s.toMap());
      }
    }
  }

  Future<List<Sale>> loadSaleRecords() async {
    List<Sale> _sale = new List();
    for (int i = 0; i < 10; i++) {
      _sale.add(this.bizCards[currentCardIndex].sales[i]);
    }
    return _sale;
  }

  Future<List<Sale>> fetchData(String start, int end) async {
    DocumentSnapshot _lastDocument;
    Query query;
    Sale _separator;
    List<Sale> _sales = [];
    if (start != null) {
      _lastDocument = await getLastDocumentSnapshot(start);
      _separator = Sale.fromMap(_lastDocument.data);
    }
    query = Firestore.instance.collection(
        '/customers/${_user.id}/cards/${this.bizCards[currentCardIndex].docID}/sales');
    if (_lastDocument != null) {
      query = query.endAtDocument(_lastDocument);
    } else {
      query = query.orderBy('date', descending: true);
    }
    query = query.limit(end);
    var sale = await query.getDocuments();
    sale.documents.forEach((doc) {
      var _s = Sale.fromMap(doc.data);
      if (_separator != null) {
        if (_s.date.month != _separator.date.month) {
          _s.separator = true;
          _separator = _s;
        }
      }
      _s.docID = doc.documentID;
      _sales.add(_s);
    });
    return Future.delayed(Duration(seconds: 1), () {
      return _sales;
    });
  }
  Future<void> generateSession() async {
    var _up = BizCard(
        bizID: getCurrentCard().bizID,
        docID: getCurrentCard().docID,
        cardNum: getCurrentCard().cardNum,
        bizName: getCurrentCard().bizName,
        point: getCurrentCard().point,
        sessionNum: Uuid().v4(),
        sessionTime: DateTime.now());
    await Firestore.instance
        .collection('customers')
        .document(_user.id)
        .collection('cards')
        .document(getCurrentCard().docID)
        .updateData(_up.toMap());
  }

  Future<List<Sale>> refreshData(int limit) async {
    return await fetchData(null, limit);
  }

  Future<DocumentSnapshot> getLastDocumentSnapshot(String start) async {
    return await Firestore.instance
        .collection('customers')
        .document(_user.id)
        .collection('cards')
        .document(this.bizCards[currentCardIndex].docID)
        .collection('sales')
        .document(start)
        .get();
  }
}
