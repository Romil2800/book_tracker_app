import 'package:book_tracker_app/screens/getStartedPage.dart';
import 'package:book_tracker_app/screens/login_page.dart';
import 'package:book_tracker_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'screens/page_not_found.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: widget,
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => GetStartedPage(),
        //   '/main': (context) => MainScreenPage(),
        //   '/login': (context) => LoginPage(),
        // },
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingName: settings.name);
            },
          );
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return PageNotFound();
          });
        },
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String settingName;

  const RouteController({Key key, this.settingName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User>(context) != null;
    final signedInGotoMain = userSignedIn && settingName == '/main';
    final notSignedIngotoMain = !userSignedIn && settingName == '/main';
    if (settingName == '/') {
      return GetStartedPage();
    } else if (settingName == '/login' || notSignedIngotoMain) {
      return LoginPage();
    } else if (signedInGotoMain) {
      return MainScreenPage();
    } else {
      return PageNotFound();
    }
  }
}
