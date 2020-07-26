import 'package:mokkon_cards/model/cardModel/sale.dart';

class BizCard {
  String docID;
  final String bizID;
  final String bizName;
  final String cardNum;
  final String sessionNum;
  final DateTime sessionTime;

  List<Sale> sales;
  final int point;
  String get getdocID => this.docID;
  String get getbizID => this.bizID;
  String get getbizName => this.bizName;
  String get getCardNumber => this.cardNum;
  int get getPoint => this.point;
  List<Sale> get getSales => this.sales;

  BizCard(
      {this.sessionNum,
      this.sessionTime,
      this.docID,
      this.bizName,
      this.bizID,
      this.cardNum,
      this.point,
      this.sales});

  factory BizCard.fromJson(Map<String, dynamic> parsedJson) {
    return BizCard(
      bizName: parsedJson['biz_name'],
      bizID: parsedJson['biz_id'],
      cardNum: parsedJson['card_num'],
      point: parsedJson['point'],
    );
  }

  Map<String, dynamic> toJson() => {
        'biz_name': bizName,
        'biz_id': bizID,
        'card_num': cardNum,
        'point': point
      };
  Map<String, dynamic> toMap() {
    return {
      'session_num': sessionNum,
      'session_time': sessionTime,
      'biz_name': bizName,
      'biz_id': bizID,
      'card_num': cardNum,
      'point': point,
    };
  }

  factory BizCard.fromMap(Map<String, dynamic> map) {
    return BizCard(
        sessionNum: map['session_num'],
        sessionTime: map['session_time'].toDate(),
        bizName: map['biz_name'],
        bizID: map['biz_id'],
        cardNum: map['card_num'],
        point: map['point']);
  }
  @override
  String toString() {
    return 'BizCard{sessionNum:$sessionNum,sessionTime:$sessionTime,docID:$docID,bizName: $bizName, bizID:$bizID,cardNum:$cardNum,point:$point,sale:$sales}';
  }
}

class Biz {
  final String name;
  String docID;
  Biz({this.name});
  @override
  factory Biz.fromMap(Map<String, dynamic> map) {
    return Biz(
      name: map['name'],
    );
  }
  String toString() {
    return 'Biz{name:$name}';
  }
}
