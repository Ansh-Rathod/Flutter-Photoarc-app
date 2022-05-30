import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';
import '../../widgets/post_image.dart';
import '../verify-email/verify_email.dart';
import 'cubit/upload_image_cubit.dart';

class AddPost extends StatefulWidget {
  final UserModel currentUser;
  const AddPost({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController cation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadImageCubit(),
      child: BlocConsumer<UploadImageCubit, UploadImageState>(
        listener: (context, state) {
          if (state.picStatus == ImageStatus.error) {
            showSnackBarToPage(
                context, 'Please Try again later.', Colors.redAccent);
          }

          if (state.picStatus == ImageStatus.success) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CupertinoNavigationBar(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade800, width: .4)),
              backgroundColor: Colors.black,
              middle: const Text(
                "Add Post",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'EuclidTriangle',
                  color: Colors.white,
                ),
              ),
              trailing: CupertinoButton(
                onPressed: state.image != null &&
                        state.picStatus != ImageStatus.loading
                    ? () async {
                        FocusScope.of(context).unfocus();
                        BlocProvider.of<UploadImageCubit>(context).uploadImage(
                            state.image!, cation.text, widget.currentUser);
                      }
                    : null,
                child: Icon(
                  CupertinoIcons.check_mark,
                  color: Theme.of(context).primaryColor,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            body: state.picStatus == ImageStatus.loading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      physics: state.picStatus == ImageStatus.loading
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () async {
                              final pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);

                              CroppedFile? croppedFile =
                                  await ImageCropper().cropImage(
                                sourcePath: pickedFile!.path,
                                aspectRatioPresets: [
                                  CropAspectRatioPreset.square,
                                  CropAspectRatioPreset.ratio3x2,
                                  CropAspectRatioPreset.original,
                                  CropAspectRatioPreset.ratio4x3,
                                  CropAspectRatioPreset.ratio16x9
                                ],
                              );

                              BlocProvider.of<UploadImageCubit>(context)
                                  .updateImage(File(croppedFile!.path));
                            },
                            child: PostImage(path: state.image),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: cation,
                            maxLines: null,
                            maxLength: 300,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(CupertinoIcons.info,
                                  color: Colors.white),
                              hintText: 'Caption',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
