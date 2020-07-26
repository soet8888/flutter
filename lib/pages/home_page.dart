import 'package:flutter/material.dart';
import 'package:mokkon_cards/widgets/history/history.dart';
import 'package:mokkon_cards/widgets/card.dart';
import '../widgets/profile.dart';

import 'package:mokkon_cards/theme/theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  Widget appBarTitle = new Text(
    "Card",
    textAlign: TextAlign.center,
  );
  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: mCardColor,
        bottomNavigationBar: new Material(
            color: mCardColor,
            child: new TabBar(controller: controller, tabs: <Tab>[
              new Tab(
                  icon: new Icon(
                Icons.card_giftcard,
                size: 30.0,
                color: Colors.white,
              )),
              new Tab(
                  icon: new Icon(
                Icons.history,
                size: 30.0,
                color: Colors.white,
              )),
              new Tab(
                  icon: new Icon(
                Icons.account_box,
                size: 30.0,
                color: Colors.white,
              )),
            ])),
        body: new TabBarView(controller: controller, children: <Widget>[
          new PaymentCard(),
          new CardHistory(),
          new Profile(),
        ]));
  }
}
