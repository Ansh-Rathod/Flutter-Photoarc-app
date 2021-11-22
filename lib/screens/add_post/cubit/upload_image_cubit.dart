import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../../models/user_model.dart';
import '../../../models/error_model.dart';
import '../../../repo/create_post.dart';

part 'upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageState.inital());
  final repo = CreatePost();

  void updateImage(File file) => emit(state.copyWith(image: file));

  Future<void> uploadData({
    required String caption,
    required String url,
    required UserModel user,
    required int height,
    required int width,
  }) async {
    final status = await repo.uploadPost(
      caption: caption,
      url: url,
      uid: user.id,
      height: height,
      width: width,
    );
    if (status != 202) {
      emit(state.copyWith(picStatus: ImageStatus.error));
      throw ErrorModel(code: 404.toString(), message: 'error');
    }
  }

  void uploadImage(File file, String caption, UserModel user) async {
    try {
      emit(state.copyWith(picStatus: ImageStatus.loading));
      final url = await repo.uploadImage(file);
      // print(url['data']['width']);
      await uploadData(
        caption: caption,
        url: url['data']['secure_url'],
        user: user,
        width: url['data']['width'],
        height: url['data']['height'],
      );
      emit(state.copyWith(picStatus: ImageStatus.success));
    } catch (e) {
      // print(e.toString());
      emit(state.copyWith(picStatus: ImageStatus.error));
      // }
    }
  }
}
