part of 'upload_image_cubit.dart';

enum ImageStatus { inital, success, loading, error }

class UploadImageState {
  final String? error;
  final ImageStatus picStatus;
  final File? image;
  UploadImageState({
    this.error,
    required this.picStatus,
    this.image,
  });

  factory UploadImageState.inital() {
    return UploadImageState(error: '', picStatus: ImageStatus.inital);
  }

  UploadImageState copyWith({
    String? error,
    ImageStatus? picStatus,
    File? image,
  }) {
    return UploadImageState(
      error: error ?? this.error,
      picStatus: picStatus ?? this.picStatus,
      image: image ?? this.image,
    );
  }
}
