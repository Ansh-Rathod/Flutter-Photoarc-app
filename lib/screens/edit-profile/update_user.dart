// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/screens/edit-profile/cubit/update_user_cubit.dart';

class UpdateUser extends StatefulWidget {
  final UserModel currentUser;
  const UpdateUser({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController website = TextEditingController();
  TextEditingController bio = TextEditingController();
  @override
  void initState() {
    name.text = widget.currentUser.name;
    website.text = widget.currentUser.url;
    bio.text = widget.currentUser.bio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateUserCubit(),
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "UPDATE PROFILE",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          border: Border(
              bottom: BorderSide(width: .4, color: Colors.grey.shade600)),
          backgroundColor: Colors.transparent,
        ),
        body: BlocConsumer<UpdateUserCubit, UpdateUserState>(
          listener: (context, state) {
            if (state.status == UserStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 4),
                  dismissDirection: DismissDirection.horizontal,
                  backgroundColor: Colors.redAccent,
                  content: Text(state.error!),
                ),
              );
            }
            if (state.status == UserStatus.success) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      TextFormField(
                        controller: name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        validator: (val) => val!.isEmpty && val.length > 4
                            ? 'Please fill the field and must be more than 4 characters'
                            : null,
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
                            hintText: 'Add some thing about You'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,
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
                                    BlocProvider.of<UpdateUserCubit>(context)
                                        .submit(
                                      name: name.text,
                                      bio: bio.text,
                                      website: website.text,
                                    );
                                    Phoenix.rebirth(context);
                                  }
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              state.status != UserStatus.loading
                                  ? "UPDATE DETAILS".toUpperCase()
                                  : "UPDATING..".toUpperCase(),
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
            );
          },
        ),
      ),
    );
  }
}
