import 'package:flutter/material.dart';
import 'package:mokkon_cards/model/auth.dart';
import 'package:mokkon_cards/model/biz_card_model.dart';
import 'package:mokkon_cards/model/cardModel/biz_card.dart';
import 'package:mokkon_cards/widgets/add_card.dart';
import 'package:provider/provider.dart';
import 'package:mokkon_cards/theme/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

var addCard = BizCard(bizName: 'Add', cardNum: '0000000000000000', point: 0);

class PaymentCard extends StatefulWidget {
  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  List<BizCard> cardList = [];
  int points = 0;
  String _qrDataString = '';
  bool onpay = false;
  @override
  Widget build(BuildContext context) {
    cardList = Provider.of<BizCardModel>(context).bizCards;
    if (cardList != null) {
      if (cardList.where((type) => type.bizName == 'Add').length <= 0) {
        cardList.add(addCard);
      }
    } else {
      cardList = new List();
      cardList.add(addCard);
    }
    return new Container(
      decoration: new BoxDecoration(
        color: mCardColor,
        borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
      ),
      child: new Column(
        children: <Widget>[
          SizedBox(
            width: 60.0,
            height: 50.0,
          ),
          Center(
            child: new Row(
              children: <Widget>[
                SizedBox(
                  width: 40.0,
                  height: 20.0,
                ),
                _buildAddCard(context),
              ],
            ),
          ),
          SizedBox(
            width: 30.0,
            height: 50.0,
          ),
          Expanded(
            child: new Row(
              children: <Widget>[
                SizedBox(
                  width: 80.0,
                  height: 30.0,
                ),
                new Column(
                  children: <Widget>[
                    new Text('Points',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                    new Text('$points',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                  ],
                ),
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                ),
                new Column(
                  children: <Widget>[
                    new Text('MMK',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                    new Text('-',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 120.0,
                    height: 50.0,
                  ),
                  Center(
                    child: new RaisedButton(
                      onPressed: () {},
                      highlightColor: Colors.white,
                      color: Colors.white,
                      splashColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text('Payment',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCard(BuildContext context, String name, String cardID) {
    var _space = _spacingCardNumber(cardID);
    if (name == 'Add') {
      return Center(
        child: Container(
          child: IconButton(
            icon: new Icon(Icons.add),
            iconSize: 40.0,
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBizCard()),
                ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 20.0,
          height: 10.0,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 20.0,
              height: 10.0,
            ),
            new Text(
              name,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            SizedBox(
              width: 120.0,
              height: 0.0,
            ),
            new Icon(
              Icons.card_giftcard,
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
          width: 20.0,
        ),
        new Row(
          children: <Widget>[
            SizedBox(
              height: 20.0,
              width: 20.0,
            ),
            new Tab(icon: new Image.asset("assets/icons/icon.png")),
          ],
        ),
        SizedBox(
          height: 50.0,
          width: 20.0,
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15.0,
              width: 15.0,
            ),
            new Text('John Wick',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            SizedBox(
              width: 40.0,
            ),
            Text('${_space[0]} ${_space[1]} ${_space[2]} ${_space[3]}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0))
          ],
        ),
      ],
    );
  }

  List<String> _spacingCardNumber(String cardNum) {
    List<String> _space = [
      cardNum[0] + cardNum[1] + cardNum[2] + cardNum[3],
      cardNum[4] + cardNum[5] + cardNum[6] + cardNum[7],
      cardNum[8] + cardNum[9] + cardNum[10] + cardNum[11],
      cardNum[12] + cardNum[13] + cardNum[14] + cardNum[15]
    ];
    return _space;
  }

  _buildAddCard(BuildContext context) {
    var bizCardRefs = Provider.of<BizCardModel>(context);
    var userRefs = Provider.of<UserAuth>(context);
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      width: 270.0,
      height: 200.0,
      child: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            points = cardList[index].point;
            var uuid = new Uuid();
            _qrDataString = userRefs.usr.id + ':' + cardList[index].cardNum;
            // ':' +
            // uuid.v4();
            if (cardList[index].bizName != 'Add') {
              bizCardRefs.setCurrentCard(index);
            }
          });
        },
        itemCount: cardList.length,
        itemBuilder: (context, index) {
          return Container(
            width: 260,
            height: 185,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: InkWell(
                onTap: () async {
                  if (onpay) {
                   await bizCardRefs.generateSession();
                  }
                  setState(() {
                    onpay = !onpay;
                  });
                },
                child: onpay
                    ? _buildQr()
                    : _buildCard(context, cardList[index].bizName,
                        cardList[index].cardNum),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  _buildQr() {
    print("QR DATAT: $_qrDataString");
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: QrImage(
                size: 150.0,
                data: _qrDataString,
                gapless: false,
                foregroundColor: const Color(0xFF111111),
                onError: (dynamic ex) {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
