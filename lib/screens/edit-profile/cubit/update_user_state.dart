part of 'update_user_cubit.dart';

enum UserStatus {
  loading,
  success,
  error,
  inital,
}
enum ImageStatus { inital, success, loading, error }

class UpdateUserState {
  final UserStatus status;
  final String? error;
  final ImageStatus picStatus;
  final File? image;
  UpdateUserState({
    required this.status,
    this.error,
    required this.picStatus,
    this.image,
  });

  factory UpdateUserState.inital() {
    return UpdateUserState(
      status: UserStatus.inital,
      error: '',
      picStatus: ImageStatus.inital,
      image: null,
    );
  }

  UpdateUserState copyWith({
    UserStatus? status,
    String? error,
    ImageStatus? picStatus,
    File? image,
  }) {
    return UpdateUserState(
      status: status ?? this.status,
      error: error ?? this.error,
      picStatus: picStatus ?? this.picStatus,
      image: image ?? this.image,
    );
  }
}
