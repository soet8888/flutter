import 'package:flutter/material.dart';
import 'package:mokkon_cards/model/auth.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var userAuth = Provider.of<UserAuth>(context);
    var _name = userAuth.usr.name;
    return new Container(
      decoration: new BoxDecoration(
        color: mCardColor,
        borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100.0,
            width: 40.0,
          ),
          Container(
            width: 100.0,
            height: 50.0,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(18.0)),
            ),
            child: Center(
              child: new Text("Profile",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          SizedBox(height: 30.0),
          Container(
            width: 250.0,
            height: 100.0,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  height: 30.0,
                  child: new Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20.0,
                      ),
                      new Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      new Text('${userAuth.usr.name}',
                          style: TextStyle(fontSize: 20.0, color: Colors.brown,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  color: Colors.transparent,
                  height: 30.0,
                  child: new Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20.0,
                      ),
                      new Text(
                        'Phone',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      new Text('${userAuth.phone}',
                          style: TextStyle(fontSize: 20.0, color: Colors.brown,fontWeight: FontWeight.bold))
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 70.0,
          ),
          Container(
              color: Colors.white,
              height: 50.0,
              width: 100.0,
              child: new RaisedButton(
                onPressed: () async {
                  userAuth.logout();
                  Navigator.pushNamed(context, '/login');
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
                child: Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/m.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/john.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }
}
