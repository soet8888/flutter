import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mokkon_cards/main.dart';
import 'package:mokkon_cards/model/cardModel/sale.dart';
import 'package:mokkon_cards/theme/theme.dart';

class CardHistory extends StatefulWidget {
  @override
  _CardHistoryState createState() => _CardHistoryState();
}

class _CardHistoryState extends State<CardHistory> {
  ValueNotifier<double> _notifier;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  List<Sale> data = new List();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // _notifier?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _load();
    //  _notifier = ValueNotifier<double>(0);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        _getMoreData();
      }
    });
    super.initState();
  }

  _load() async {
    var _h = await bizCard.loadSaleRecords();
    data.clear();
    _h.forEach((v) => data.add(v));
    setState(() {});
  }

  _getMoreData() async {
    if (!isLoading) {
      setState(() => isLoading = true);
      if (data.length >= 400) {
        await Future.delayed(Duration(seconds: 3));
        setState(() => isLoading = false);
        await makeAnimation();
        scaffoldKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Get max data!'),
          ),
        );
        return;
      }
      final _newData = await bizCard.fetchData(data.last.docID, 10);
      data.addAll(_newData);
      isLoading = false;
      setState(() {});
    }
  }

  makeAnimation() async {
    final offsetFromBottom =
        scrollController.position.maxScrollExtent - scrollController.offset;
    if (offsetFromBottom < 50) {
      await scrollController.animateTo(
        scrollController.offset - (50 - offsetFromBottom),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  final List<Color> seperatorColors = [mCardColor, Colors.black, Colors.green];
  Color randomGenerator() {
    return seperatorColors[new Random().nextInt(2)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Column(
          children: <Widget>[
            Card(
              borderOnForeground: true,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0),
              ),
              child: Container(
                height: 40.0,
                width: 250,
                alignment: Alignment.center,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    "${bizCard.getCurrentCard().bizName}  =>  ${bizCard.getCurrentCard().point} points",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 70.0,
            //       ),
            //       IconButton(
            //         onPressed: () {
            //           NotifyingPageView().setNextPage('left');
            //         },
            //         icon: new Icon(
            //           Icons.arrow_left,
            //           color: Colors.white,
            //         ),
            //       ),
            //       Container(
            //         color: Colors.transparent,
            //         width: 90,
            //         child: NotifyingPageView(
            //           notifier: _notifier,
            //         ),
            //       ),
            //       IconButton(
            //         onPressed: () {
            //           NotifyingPageView().setNextPage('right');
            //         },
            //         icon: new Icon(
            //           Icons.arrow_right,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 5.0,
              width: 20,
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: 500,
                  width: 350,
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.black),
                    color: Colors.white,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: new BoxDecoration(
                              border: new Border.all(color: Colors.white),
                              color: mCardColor),
                          child: IconButton(
                            icon: Icon(Icons.refresh),
                            color: Colors.white,
                            onPressed: () async {
                              data
                                ..clear()
                                ..addAll(await bizCard.refreshData(10));
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 380,
                          width: 350,
                          child: RefreshIndicator(
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(
                                  color: randomGenerator(),
                                );
                              },
                              controller: scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                if (index < data.length - 1) {
                                  return Center(
                                    child: data[index].separator
                                        ? ListTile(
                                            trailing: Text(
                                              '${_toMonth(data[index].date.month)} ${data[index].date.year}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : ListTile(
                                            title: Text(
                                              '${data[index].date}          ${data[index].amt}',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            trailing: Text(
                                              '${data[index].point}',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                  );
                                }
                                print("LOAING CIRCLE");
                                return Center(
                                  child: Opacity(
                                    opacity: isLoading ? 1.0 : 0.0,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              itemCount: data.length,
                            ),
                            onRefresh: () async {
                              data
                                ..clear()
                                ..addAll(await bizCard.refreshData(10));
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _toMonth(int month) {
    String _m;
    switch (month) {
      case 1:
        {
          _m = "January";
        }
        break;
      case 2:
        {
          _m = "February";
        }
        break;
      case 3:
        {
          _m = "March";
        }
        break;
      case 4:
        {
          _m = "April";
        }
        break;
      case 5:
        {
          _m = "May";
        }
        break;
      case 6:
        {
          _m = "June";
        }
        break;
      case 7:
        {
          _m = "July";
        }
        break;
      case 8:
        {
          _m = "August";
        }
        break;
      case 9:
        {
          _m = "September";
        }
        break;
      case 10:
        {
          _m = "October";
        }
        break;
      case 11:
        {
          _m = "November";
        }
        break;
      case 12:
        {
          _m = "December";
        }
        break;
    }
    return _m;
  }
}
