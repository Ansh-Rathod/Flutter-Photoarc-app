import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade700,
                width: .5,
              ),
            ),
            stretch: true,
            backgroundColor: Colors.black87,
            largeTitle: const Text(
              "About",
              style: TextStyle(
                fontFamily: 'EuclidTriangle',
                color: Colors.white,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  minLeadingWidth: 20,
                  leading: Icon(
                    CupertinoIcons.info,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text(
                    "Made By Ansh Rathod",
                    style: TextStyle(
                      fontFamily: 'EuclidTriangle',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "with flutter and node js as backend.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Divider(
                  thickness: .4,
                  color: Colors.grey.shade900,
                ),
                ListTile(
                  onTap: () {
                    launch("https://twitter.com/appiirathod");
                  },
                  minLeadingWidth: 20,
                  leading: Icon(
                    FontAwesomeIcons.twitter,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text(
                    "Follow me on twitter",
                    style: TextStyle(
                      fontFamily: 'EuclidTriangle',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade800,
                  ),
                  subtitle: Text(
                    "Stay on top of latest updates.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Divider(
                  thickness: .4,
                  color: Colors.grey.shade900,
                ),
                ListTile(
                  onTap: () {
                    launch("https://github.com/Ansh-Rathod");
                  },
                  minLeadingWidth: 20,
                  leading: Icon(
                    FontAwesomeIcons.github,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade800,
                  ),
                  title: const Text(
                    "Follow me on github",
                    style: TextStyle(
                      fontFamily: 'EuclidTriangle',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "for my new upcoming projects.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Divider(
                  thickness: .4,
                  color: Colors.grey.shade900,
                ),
                ListTile(
                  onTap: () {
                    launch(
                        'https://www.linkedin.com/in/ansh-rathod-478a81210/');
                  },
                  minLeadingWidth: 20,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade800,
                  ),
                  leading: Icon(
                    FontAwesomeIcons.linkedin,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text(
                    "Connect me on Linkdin",
                    style: TextStyle(
                      fontFamily: 'EuclidTriangle',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "To see my previous posts about flutter",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Divider(
                  thickness: .4,
                  color: Colors.grey.shade900,
                ),
                ListTile(
                  minLeadingWidth: 20,
                  onTap: () {
                    launch(
                        'https://github.com/Ansh-Rathod/Flutter-Photoarc-app');
                  },
                  leading: Icon(
                    CupertinoIcons.star,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade800,
                  ),
                  title: const Text(
                    "Give a star",
                    style: TextStyle(
                      fontFamily: 'EuclidTriangle',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Go To github repository of app.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Divider(
                  thickness: .4,
                  color: Colors.grey.shade900,
                ),
                ListTile(
                  onTap: () {
                    launch(
                        'mailto:anshrathod322@gmail.com?subject=Bug report (Photoarc)&body=Hi,i want to report a bug.');
                  },
                  minLeadingWidth: 20,
                  leading: Icon(
                    FontAwesomeIcons.bug,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade800,
                  ),
                  title: const Text(
                    "Report a Bug",
                    style: TextStyle(
                      fontFamily: 'EuclidTriangle',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Help me to imporve the application.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Divider(
                  thickness: .4,
                  color: Colors.grey.shade900,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();

                        SharedPreferences prefrences =
                            await SharedPreferences.getInstance();
                        await prefrences.remove('isLogin');
                        await prefrences.remove('verify');
                        await prefrences.remove('createuser');
                        var box = Hive.box('notifications');
                        await box.clear();
                        Future.delayed(const Duration(microseconds: 500), () {
                          Phoenix.rebirth(context);
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
