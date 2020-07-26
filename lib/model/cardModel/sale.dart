class Sale {
   String docID;
 final String userDoc;
  final String cardDoc;
  final int point;
  DateTime date;
  final String shop;
  final int  amt;
  bool separator=false;
  int get getpoint => this.point;
  DateTime get getdate => this.date;
  String get getshopber => this.shop;
  int get getamt => this.amt;

  Sale({this.userDoc, this.cardDoc,    this.date,
    this.point,
    this.shop,
    this.amt
  });

  factory Sale.fromJson(Map<String, dynamic> parsedJson) {
    return Sale(
      date: parsedJson['date'],
      point: parsedJson['point'],
      shop: parsedJson['shop'],
      amt: parsedJson['amt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'point': point,
        'shop':shop,
        'amt':amt
      };
  Map<String, dynamic> toMap() {
    return {
      'user_doc':userDoc,
      'card_doc':cardDoc,
      'date': date,
      'point': point,
      'shop':shop,
      'amt':amt
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      userDoc:map['user_doc'],
      cardDoc: map['card_doc'],
      date: map['date'].toDate(), 
      point: map['point'],
      shop: map['shop'],
      amt: map['amt']
    );
  }
  @override
  String toString() {
    return 'Sale{cardDoc:$cardDoc,userDoc:$userDoc,date: $date, point:$point,shop:$shop,amt:$amt}';
  }
}