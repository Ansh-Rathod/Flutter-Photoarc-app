import 'package:bloc/bloc.dart';
import '../../../models/error_model.dart';
import '../../../repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());
  final repo = AuthRepo();

  void authenticate(String email, String password) async {
    try {
      emit(state.copyWith(
        status: AuthStatus.submitting,
      ));
      await repo.login(email, password);
      SharedPreferences prefrences = await SharedPreferences.getInstance();
      await prefrences.setBool('isLogin', true);
      await prefrences.setBool('verify', true);
      await prefrences.setBool('createuser', true);
      emit(state.copyWith(status: AuthStatus.logInSuccess));
    } on ErrorModel catch (e) {
      // print(e.code);
      if (e.code == 'user-not-found') {
        emit(state.copyWith(status: AuthStatus.createingAccount));
        signUp(email, password);
      } else {
        emit(state.copyWith(
          error: e,
          status: AuthStatus.error,
        ));
      }
    } catch (e) {
      // print(e.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void signUp(String email, String password) async {
    try {
      emit(state.copyWith(
        status: AuthStatus.submitting,
      ));
      // print("signing up");
      await repo.createAccount(email, password);

      SharedPreferences prefrences = await SharedPreferences.getInstance();
      prefrences.setBool('isLogin', true);
      emit(state.copyWith(status: AuthStatus.signUpSuccess));
    } on ErrorModel catch (e) {
      // print("error signing up");

      emit(state.copyWith(
        error: e,
        status: AuthStatus.error,
      ));
    } catch (e) {
      // print(e.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }
}
