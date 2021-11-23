import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../repo/create_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'create_user_state.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  CreateUserCubit() : super(CreateUserState.inital());
  final repo = CreateUserRepo();

  void submit(
      {required String name,
      required String bio,
      required String website}) async {
    try {
      emit(state.copyWith(status: UserStatus.loading));
      int code = await repo.createUser(
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
        SharedPreferences prefrences = await SharedPreferences.getInstance();
        await prefrences.setBool('createuser', true);
        emit(state.copyWith(status: UserStatus.success));
      }
    } catch (e) {
      // print(e.toString());
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
