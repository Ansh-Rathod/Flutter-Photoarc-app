// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:social_media/screens/create-user/cubit/create_user_cubit.dart';
import 'package:social_media/screens/verify-email/verify_email.dart';
import 'package:social_media/widgets/user_profile.dart';

import '../../animation.dart';

class AddProfile extends StatelessWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateUserCubit(),
      child: Scaffold(
        body: BlocConsumer<CreateUserCubit, CreateUserState>(
          listener: (context, state) {
            if (state.picStatus == ImageStatus.error) {
              showSnackBarToPage(
                  context, 'Please try again later.', Colors.redAccent);
            }

            if (state.picStatus == ImageStatus.success) {
              Navigator.pushReplacement(
                context,
                createRoute(
                  const BottomNavBar(),
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () async {
                              final pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);

                              CroppedFile? croppedFile =
                                  await ImageCropper().cropImage(
                                sourcePath: pickedFile!.path,
                                cropStyle: CropStyle.rectangle,
                                aspectRatioPresets: [
                                  CropAspectRatioPreset.square,
                                ],
                              );
                              if (croppedFile != null) {
                                BlocProvider.of<CreateUserCubit>(context)
                                    .addImage(
                                  File(croppedFile.path),
                                );
                              }
                            },
                            child: UserProfile(size: 150, path: state.image)),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Add Profile image".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 24),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Text(
                            "Add Profile Image that your friends know, it's you.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1!),
                        const SizedBox(
                          height: 24,
                        ),
                        RaisedButton(
                          elevation: 0,
                          hoverElevation: 0,
                          focusElevation: 0,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          disabledColor: Colors.grey.shade700,
                          onPressed: state.picStatus != ImageStatus.loading
                              ? () async {
                                  if (state.image != null) {
                                    BlocProvider.of<CreateUserCubit>(context)
                                        .uploadImage(state.image!);
                                  } else {
                                    showSnackBarToPage(
                                        context,
                                        'Please add profile image first.',
                                        Colors.redAccent);
                                  }
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                                state.picStatus != ImageStatus.loading
                                    ? "Continue".toUpperCase()
                                    : "uploading..".toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              createRoute(
                                const BottomNavBar(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Skip".toUpperCase()),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
