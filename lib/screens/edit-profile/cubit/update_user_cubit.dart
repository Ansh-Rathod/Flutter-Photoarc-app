import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../../../repo/create_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'update_user_state.dart';

class UpdateUserCubit extends Cubit<UpdateUserState> {
  UpdateUserCubit() : super(UpdateUserState.inital());
  final repo = CreateUserRepo();

  void submit(
      {required String name,
      required String bio,
      required String website}) async {
    try {
      emit(state.copyWith(status: UserStatus.loading));
      int code = await repo.updateUser(
        name: name,
        id: FirebaseAuth.instance.currentUser!.uid,
        website: website,
        bio: bio,
      );
      if (code == 500) {
        emit(
          state.copyWith(
              status: UserStatus.error, error: 'INTERNAL SERVER ERROR'),
        );
      } else if (code == 202) {
        emit(state.copyWith(status: UserStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
            status: UserStatus.error, error: 'INTERNAL SERVER ERROR'),
      );
    }
  }

  void addImage(File image) async {
    emit(state.copyWith(image: image));
  }

  void uploadImage(File image) async {
    try {
      emit(state.copyWith(picStatus: ImageStatus.loading));

      final code =
          await repo.uploadImage(image, FirebaseAuth.instance.currentUser!.uid);
      // print(code);
      if (code == 202) {
        emit(state.copyWith(picStatus: ImageStatus.success));
      } else {
        emit(state.copyWith(picStatus: ImageStatus.error));
      }
    } catch (e) {
      // print(e.toString());
      emit(state.copyWith(picStatus: ImageStatus.error));
    }
  }
}
