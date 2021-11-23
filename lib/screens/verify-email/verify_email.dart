// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/screens/create-user/create_user.dart';

import '../../animation.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.mail,
              size: 150, color: Theme.of(context).primaryColor),
          Text(
            'Verify your email'.toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'We sent you an email to verify your email address. Please check your email and click the link to verify your email address.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.3),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Resend email'.toUpperCase()),
                  ),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      showSnackBarToPage(
                        context,
                        "Email sent successfully.",
                        Colors.green,
                      );
                    } catch (e) {
                      showSnackBarToPage(
                        context,
                        "We have blocked all requests from this device due to unusual activity. Try again later.",
                        Colors.redAccent,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    await user!.reload();
                    user = FirebaseAuth.instance.currentUser;

                    if (user!.emailVerified) {
                      SharedPreferences prefrences =
                          await SharedPreferences.getInstance();
                      await prefrences.setBool('verify', true);
                      Navigator.of(context).pushReplacement(
                        createRoute(
                          const CreateUser(),
                        ),
                      );
                    } else {
                      showSnackBarToPage(
                        context,
                        "Your email address is not verified yet.",
                        Colors.redAccent,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'continue'.toUpperCase(),
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}

showSnackBarToPage(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.all(18),
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: color,
      content: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}
