import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_model.dart';
import 'cubit/current_user_cubit.dart';
import '../feed/feed.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile.dart';
import '../search/search_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    buildCurrentPage(int i, UserModel value) {
      switch (i) {
        case 0:
          return FeedScreen(
            currentUser: value,
          );
        case 1:
          return SearchPage(
            currentUser: value,
          );
        case 2:
          return NotificationPage(
            currentUser: value,
          );
        case 3:
          return ProfileScreen(
            id: FirebaseAuth.instance.currentUser!.uid,
            currentUser: value,
          );
        default:
          return Container();
      }
    }

    return BlocProvider(
      create: (context) => CurrentUserCubit()
        ..setCurrentUser(FirebaseAuth.instance.currentUser!.uid),
      child: BlocBuilder<CurrentUserCubit, CurrentUserState>(
        builder: (context, state) {
          if (state.status == CurrentUserStatus.loading) {
            return Scaffold(
              extendBody: true,
              body: Center(
                child: Image.asset(
                  'assets/fonts/depositphotos_83057730-stock-illustration-p-letter-monogram-logo-removebg-preview.png',
                  width: 350,
                  height: 350,
                  fit: BoxFit.fill,
                ),
              ),
            );
          } else if (state.status == CurrentUserStatus.loaded) {
            return Scaffold(
              body: buildCurrentPage(currentIndex, state.user),
              bottomNavigationBar: CupertinoTabBar(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade800,
                    width: .4,
                  ),
                ),
                backgroundColor: Colors.transparent,
                onTap: (index) {
                  if (index == 2) {
                    BlocProvider.of<CurrentUserCubit>(context).changeIcon();
                  }
                  setState(() {
                    currentIndex = index;
                  });
                },
                inactiveColor: Colors.grey,
                activeColor: Theme.of(context).primaryColor,
                currentIndex: currentIndex,
                iconSize: 26.0,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    activeIcon: Icon(CupertinoIcons.house_fill),
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.search),
                  ),
                  BottomNavigationBarItem(
                    icon: !state.isNote
                        ? const Icon(CupertinoIcons.bell)
                        : const Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.orange,
                          ),
                    activeIcon: const Icon(CupertinoIcons.bell_solid),
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person),
                    activeIcon: Icon(CupertinoIcons.person_fill),
                  ),
                ],
              ),
            );
          } else if (state.status == CurrentUserStatus.error) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '404',
                      style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "User not found",
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonTheme(
                      child: ElevatedButton(
                          onPressed: () {
                            launch(
                                'mailto:anshrathod322@gmail.com?subject=Bug report (Photoarc)&body=Hi,i want to report a bug.');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("Report an issue"),
                          )),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
