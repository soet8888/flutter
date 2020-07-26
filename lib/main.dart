import 'package:flutter/material.dart';
import 'package:mokkon_cards/model/biz_card_model.dart';
import 'package:mokkon_cards/model/bizs_model.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'theme/theme.dart';
import 'widgets/signup.dart';
import 'model/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
 BizCardModel bizCard = new BizCardModel();
class _MyAppState extends State<MyApp> {
  final BizModel biz = new BizModel();
  final UserAuth userAuth = new UserAuth();
  _MyAppState() {
    userAuth.addModel(biz);
    userAuth.addModel(bizCard);
  }
  Map<String, WidgetBuilder> route(BuildContext context, UserAuth userAuth) {
    final routes = <String, WidgetBuilder>{
      '/': (_) {
        {
          if (userAuth.isLogin()) {
            return HomePage();
          } else {
            return LoginPage();
          }
        }
      },
      '/login': (context) => LoginPage(),
      '/home': (context) => HomePage(),
      '/signup': (context) => Signup(),
    };
    return routes;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => userAuth..loadUser()),
        ChangeNotifierProvider(builder: (context) => biz),
        ChangeNotifierProvider(builder: (context) => bizCard),
      ],
      child: Consumer<UserAuth>(builder: (context, userAuth, child) {
        return MaterialApp(
          title: 'Mokkon',
          debugShowCheckedModeBanner: true,
          theme: theme,
          routes: route(context, userAuth),
        );
      }),
    );
  }
}
