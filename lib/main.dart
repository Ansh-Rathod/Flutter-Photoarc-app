// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

import 'api/notification_msg.dart';

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
    styleInformation: BigTextStyleInformation(''),
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
    var android = const AndroidInitializationSettings('ic_stat_letter_p');
    var iOS = const IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);
    final repo = GetNotifications();

    try {
      final result = await repo
          .getNotifications(genrateId(FirebaseAuth.instance.currentUser!.uid));
      if (result.isNotEmpty) {
        String text = buildnotification(result);
        showNotification(text, flp);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }

    return Future.value(true);
  });
}
