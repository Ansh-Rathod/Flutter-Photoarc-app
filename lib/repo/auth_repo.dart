import '../models/error_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  Future<bool> createAccount(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      userCredential.user!.sendEmailVerification();

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        throw ErrorModel(
          message: 'Provided Password is too weak.',
          code: e.code,
        );
      }
      return false;
    } catch (e) {
      // print(e);
      throw ErrorModel(
        message: 'Sorry, Something wents wrong from our side.',
        code: '500',
      );
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        throw ErrorModel(
            message: "No user found for that email.", code: e.code);
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        throw ErrorModel(message: "Wrong Password", code: e.code);
      }
      return false;
    } catch (e) {
      // print(e.toString());
      throw ErrorModel(
        message: 'Sorry, Something wents wrong from our side.',
        code: '500',
      );
    }
  }
}
