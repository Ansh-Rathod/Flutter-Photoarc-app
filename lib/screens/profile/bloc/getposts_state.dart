part of 'getposts_bloc.dart';

enum EventStatus {
  loading,
  loaded,
  error,
}

abstract class GetProfileState extends Equatable {
  const GetProfileState();

  @override
  List<Object> get props => [];
}

class GetProfileInitial extends GetProfileState {}

class GetProfileLoading extends GetProfileState {}

class GetProfileLoaded extends GetProfileState {
  final List<PostModel> posts;
  final UserModel user;
  const GetProfileLoaded({
    required this.posts,
    required this.user,
  });
}

class GetProfileError extends GetProfileState {}
