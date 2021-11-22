// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:social_media/screens/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefrences = await SharedPreferences.getInstance();
  bool? islogin = prefrences.getBool('isLogin');
  runApp(
    Phoenix(
      child: MyApp(
        isLogin: islogin,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool? isLogin;
  const MyApp({
    Key? key,
    this.isLogin,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black, // navigation bar color
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.grey.shade900,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PHOTOARC',
      theme: ThemeData(
        fontFamily: 'trebuc',
        splashColor: const Color.fromARGB(100, 41, 98, 255),
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: const Color.fromARGB(1, 19, 23, 34),
        primaryColor: const Color.fromARGB(255, 41, 98, 255),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color.fromARGB(255, 41, 98, 255),
          circularTrackColor: Color.fromARGB(200, 41, 98, 255),
          linearTrackColor: Color.fromARGB(2, 41, 98, 255),
          refreshBackgroundColor: Colors.black,
          linearMinHeight: .5,
        ),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 41, 98, 255),
          elevation: 0,
          brightness: Brightness.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'EuclidTriangle',
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: 'EuclidTriangle',
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          bodyText1: TextStyle(
            fontFamily: 'trebuc',
            fontSize: 16,
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w400,
          ),
        ),
        primarySwatch: Palette.kToDark,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                color: Colors.grey.shade700,
                width: 1,
              ),
            ),
          ),
        ),
        buttonTheme: const ButtonThemeData(minWidth: double.infinity),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(.7),
          ),
          fillColor: const Color.fromARGB(255, 30, 34, 45),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade600,
              width: .5,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade600,
              width: .5,
            ),
          ),
        ),
      ),
      builder: (context, child) {
        return MediaQuery(
          child: ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: child!,
          ),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      home: isLogin != null ? const BottomNavBar() : const AuthPage(),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
