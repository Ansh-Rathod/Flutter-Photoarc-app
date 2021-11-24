import 'package:social_media/screens/verify-email/verify_email.dart';

import '../../animation.dart';
import 'upload_profile.dart';

import 'cubit/create_user_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUser extends StatelessWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    TextEditingController name = TextEditingController();
    TextEditingController website = TextEditingController();
    TextEditingController bio = TextEditingController();
    return BlocProvider(
      create: (context) => CreateUserCubit(),
      child: Scaffold(
        body: BlocConsumer<CreateUserCubit, CreateUserState>(
          listener: (context, state) {
            if (state.status == UserStatus.error) {
              showSnackBarToPage(
                  context, 'Internal Server Error', Colors.redAccent);
            }
            if (state.status == UserStatus.success) {
              Navigator.of(context).pushReplacement(
                createRoute(
                  const AddProfile(),
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
                child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ADD SOME DETAILS',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Please fill the field' : null,
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(CupertinoIcons.person, color: Colors.white),
                          hintText: 'Name',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: website,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(CupertinoIcons.link, color: Colors.white),
                          hintText: 'Website',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: bio,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                        maxLength: 300,
                        decoration: const InputDecoration(
                            prefixIcon:
                                Icon(CupertinoIcons.info, color: Colors.white),
                            hintText: 'Add some thing about you'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // ignore: deprecated_member_use
                      ButtonTheme(
                        minWidth: double.infinity,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          elevation: 0,
                          hoverElevation: 0,
                          disabledColor: Colors.grey,
                          focusElevation: 0,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: state.status != UserStatus.loading
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    BlocProvider.of<CreateUserCubit>(context)
                                        .submit(
                                      name: name.text,
                                      bio: bio.text,
                                      website: website.text,
                                    );
                                  }
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              state.status != UserStatus.loading
                                  ? "Continue".toUpperCase()
                                  : "Loading..".toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          },
        ),
      ),
    );
  }
}
