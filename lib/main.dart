// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:social_media/colors.dart';
import 'package:social_media/repo/genrate_user_id.dart';
import 'package:social_media/repo/get_notifications.dart';
import 'package:social_media/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:social_media/screens/create-user/create_user.dart';
import 'package:social_media/screens/login/login_page.dart';
import 'package:social_media/screens/verify-email/verify_email.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox('notifications');
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "5",
    simplePeriodicTask,
    existingWorkPolicy: ExistingWorkPolicy.replace,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 10),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  SharedPreferences prefrences = await SharedPreferences.getInstance();
  bool? islogin = prefrences.getBool('isLogin');
  bool? isverify = prefrences.getBool('verify');
  bool? iscreateUser = prefrences.getBool('createuser');
  runApp(
    Phoenix(
      child: MyApp(
        isverify: isverify,
        iscreateUser: iscreateUser,
        isLogin: islogin,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool? isLogin;
  final bool? isverify;
  final bool? iscreateUser;

  const MyApp({
    Key? key,
    this.isLogin,
    this.isverify,
    this.iscreateUser,
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
      home: getHomeScreen(),
    );
  }

  getHomeScreen() {
    if (isLogin != null && isverify == null) {
      return const VerifyEmail();
    } else if (isLogin != null && isverify != null && iscreateUser == null) {
      return const CreateUser();
    } else if (isLogin != null && isverify != null && iscreateUser != null) {
      return const BottomNavBar();
    } else {
      return const AuthPage();
    }
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

//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";
// flutter local notification setup
void showNotification(v, FlutterLocalNotificationsPlugin flp) async {
  var android = const AndroidNotificationDetails(
    'Photoarc-ansh-rathod',
    'Follow and comments notifications',
    priority: Priority.defaultPriority,
    importance: Importance.defaultImportance,
    enableVibration: false,
    playSound: false,
    setAsGroupSummary: true,
  );
  var iOS = const IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  // await flp.
  await flp.show(0, 'Photoarc', '$v', platform, payload: 'Photoarc');
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();

    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android =
        const AndroidInitializationSettings('@drawable/ic_stat_letter_p');
    var iOS = const IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);
    final repo = GetNotifications();

    try {
      final result = await repo
          .getNotifications(genrateId(FirebaseAuth.instance.currentUser!.uid));
      print(result);
      if (result.isNotEmpty) {
        String text = buildnotification(result);
        print(text);
        showNotification(text, flp);
      }
    } catch (e) {
      print(e.toString());
    }

    return Future.value(true);
  });
}

String buildnotification(List<dynamic> result) {
  List<String> comments = [];
  List<String> comment = [];
  List<String> follow = [];
  List<String> likes = [];
  for (var element in result) {
    print(element['_type']);
    if (element['_type'] == 'LIKE') {
      likes.add(element['name']);
    } else if (element['_type'] == 'COMMENT') {
      comments.add(element['name']);
      comment.add(element['comment']);
    } else if (element['_type'] == 'FOLLOW') {
      follow.add(element['name']);
    }
  }

  if (comments.isNotEmpty && follow.isNotEmpty && likes.isNotEmpty) {
    return "You have ${comments.length} new comments, ${likes.length} likes, and ${follow.length} new followers";
  } else if (comments.isNotEmpty && follow.isNotEmpty) {
    if (comments.length == 1 && follow.length == 1) {
      return "${comments[0]} commented on your post '${comment[0]}' and ${follow[0]} started following you.";
    }
    if (comments.length == 1 && follow.length > 1) {
      return "${comments[0]} commented on your post '${comment[0]}' and ${follow.length} new followers.";
    }
    if (comments.length > 1 && follow.length == 1) {
      return "${comments.length} new comments and ${follow[0]} started following you.";
    }
    if (comments.length > 1 && follow.length > 1) {
      return "you have noticications from ${comments.length} new commenters and ${follow.length} new followers.";
    }
    return "${comments.length} new comments on your post and ${follow.length} new followers.";
  } else if (comments.isNotEmpty && likes.isNotEmpty) {
    if (comments.length == 1 && likes.length == 1) {
      return "${comments[0]} commented on your post '${comment[0]}' and ${likes[0]} liked your post.";
    }
    if (comments.length == 1 && likes.length > 1) {
      return "${comments[0]} commented on your post '${comment[0]}' and ${likes.length} new likes on your post.";
    }
    if (comments.length > 1 && likes.length == 1) {
      return "${comments.length} new comments and ${likes[0]} liked your post.";
    }
    if (comments.length > 1 && likes.length > 1) {
      return "${comments.length} new comments and ${likes.length} new likes on your post.";
    }
    return "You have ${comments.length} new comments and ${likes.length} likes on your posts.";
  } else if (comments.isNotEmpty) {
    if (comments.length == 1) {
      return "${comments[0]} commented on your post '${comment[0]}'";
    }
    if (comments.length == 2) {
      return "${comments[0]} and ${comments[1]} commented on your post.";
    }
    if (comments.length == 3) {
      return "${comments[0]}, ${comments[1]} and ${comments[2]} commented on your post.";
    }
    return "${comments.length} new comments on you post.";
  } else if (likes.isNotEmpty) {
    if (likes.length == 1) {
      return "${likes[0]} liked your post.";
    }
    if (likes.length == 2) {
      return "${likes[0]} and ${likes[1]} liked your post.";
    }
    if (likes.length == 3) {
      return "${likes[0]}, ${likes[1]} and ${likes[2]} liked your post.";
    }
    return "${likes.length} people liked your post.";
  } else if (follow.isNotEmpty) {
    if (follow.length == 1) {
      return "${follow[0]} followed you.";
    }
    if (follow.length == 2) {
      return "${follow[0]} and ${follow[1]} followed you.";
    }
    if (follow.length == 3) {
      return "${follow[0]}, ${follow[1]} and ${follow[2]} followed you.";
    }
    return "${follow.length} new people started following you.";
  } else {
    return "You have some notifications in your activity feed.";
  }
}
