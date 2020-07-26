import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mokkon_cards/model/biz_card_model.dart';
import 'package:mokkon_cards/model/bizs_model.dart';
import 'package:mokkon_cards/widgets/sms_code.dart';
import 'package:provider/provider.dart';

class AddBizCard extends StatefulWidget {
  @override
  _AddBizCardState createState() => _AddBizCardState();
}

class _AddBizCardState extends State<AddBizCard> {
  List<DropdownMenuItem> _dropDownMenuItems;
  var bizsRef;
  var bizsCardRef;
  var bizList;
  String _currentSelected;
  List<DropdownMenuItem> getDropdownData() {
    List<DropdownMenuItem> selectors = new List();
    bizList.forEach((biz) {
      selectors.add(new DropdownMenuItem(
        value: biz.name,
        child: new Text(biz.name),
      ));
    });
    return selectors;
  }
  void changedDropDownItem(selected) {
    setState(() {
      _currentSelected = selected;
    });
  }
  @override
  Widget build(BuildContext context) {
    bizsRef = Provider.of<BizModel>(context);
    bizsCardRef = Provider.of<BizCardModel>(context);
    bizList = bizsRef.bizs;
    _dropDownMenuItems = getDropdownData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 120.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              DropdownButton(
                hint: Text(
                  'select business',
                  style: TextStyle(
                      color: Colors.black, fontStyle: FontStyle.italic),
                ),
                style: Theme.of(context).textTheme.title,
                value: _currentSelected,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: new RaisedButton(
                  onPressed: () {
                    var b = bizList
                        .where((name) => name.name == _currentSelected)
                        .first;
                    bizsCardRef.addCard(b, () {
                      showMsgDialog(
                          context, 'success', ' Card Creation Success....');
                    });
                  },
                  highlightColor: Colors.white,
                  color: Colors.white,
                  splashColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text('Add',
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
    );
  }
}
