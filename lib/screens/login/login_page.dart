// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/animation.dart';
import 'package:social_media/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:social_media/screens/login/cubit/auth_cubit.dart';
import 'package:social_media/screens/verify-email/verify_email.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.error) {
              showSnackBarToPage(
                  context, state.error!.message, Colors.redAccent);
            } else if (state.status == AuthStatus.signUpSuccess) {
              Navigator.of(context).pushReplacement(
                createRoute(
                  const VerifyEmail(),
                ),
              );
            } else if (state.status == AuthStatus.logInSuccess) {
              Navigator.of(context).pushReplacement(
                createRoute(
                  const BottomNavBar(),
                ),
              );
            } else if (state.status == AuthStatus.createingAccount) {
              showSnackBarToPage(
                  context, "Creating new account..", Colors.green);
            }
          },
          builder: (context, state) {
            return Center(
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to Photoarc".toUpperCase(),
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                  ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          controller: email,
                          validator: (val) => val!.isEmpty
                              ? 'Please fill up this field'
                              : !val.contains('@')
                                  ? 'Password must be atleast 6 characters'
                                  : null,
                          decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.email_outlined, color: Colors.white),
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          obscureText: true,
                          controller: password,
                          validator: (val) => val!.isEmpty
                              ? 'Please fill the field'
                              : val.length < 6
                                  ? 'Password must be atleast 6 characters'
                                  : null,
                          decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.lock_outline, color: Colors.white),
                            hintText: 'Password',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              "Forget Password?",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          minWidth: double.infinity,
                          child: RaisedButton(
                            elevation: 0,
                            disabledTextColor:
                                const Color.fromARGB(25, 30, 20, 45),
                            disabledColor:
                                const Color.fromARGB(255, 30, 34, 45),
                            focusElevation: 0,
                            hoverElevation: 0,
                            onPressed: state.status != AuthStatus.submitting
                                ? () {
                                    FocusScope.of(context).unfocus();
                                    if (formkey.currentState!.validate()) {
                                      formkey.currentState!.save();
                                      BlocProvider.of<AuthCubit>(context)
                                          .authenticate(
                                        email.text.trim(),
                                        password.text,
                                      );
                                    }
                                  }
                                : null,
                            color: Theme.of(context).primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                  state.status == AuthStatus.submitting
                                      ? "LOADING.."
                                      : "AUTHTENTICATE",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(fontSize: 18)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
