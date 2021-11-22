part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  submitting,
  logInSuccess,
  error,
  signUpSuccess,
  createingAccount,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final ErrorModel? error;
  const AuthState({
    required this.status,
    required this.error,
  });

  @override
  List<Object?> get props => [status, error];
  factory AuthState.initial() {
    return const AuthState(
      error: null,
      status: AuthStatus.initial,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    ErrorModel? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
