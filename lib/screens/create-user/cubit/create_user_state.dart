part of 'create_user_cubit.dart';

enum UserStatus {
  loading,
  success,
  error,
  inital,
}
enum ImageStatus { inital, success, loading, error }

class CreateUserState {
  final UserStatus status;
  final String? error;
  final ImageStatus picStatus;
  final File? image;
  CreateUserState({
    required this.status,
    this.error,
    required this.picStatus,
    this.image,
  });

  factory CreateUserState.inital() {
    return CreateUserState(
      status: UserStatus.inital,
      error: '',
      picStatus: ImageStatus.inital,
      image: null,
    );
  }

  CreateUserState copyWith({
    UserStatus? status,
    String? error,
    ImageStatus? picStatus,
    File? image,
  }) {
    return CreateUserState(
      status: status ?? this.status,
      error: error ?? this.error,
      picStatus: picStatus ?? this.picStatus,
      image: image ?? this.image,
    );
  }
}
