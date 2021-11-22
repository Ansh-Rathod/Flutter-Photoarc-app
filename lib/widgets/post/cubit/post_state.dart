part of 'post_cubit.dart';

class PostState extends Equatable {
  final bool isLiked;
  final int likes;
  final PostModel post;
  final bool isDeleted;
  const PostState({
    required this.isLiked,
    required this.likes,
    required this.post,
    required this.isDeleted,
  });

  factory PostState.initial() => PostState(
        isLiked: false,
        likes: 0,
        post: PostModel(
          avatarUrl: '',
          createdAt: '',
          caption: '',
          width: 500,
          height: 500,
          likes: [],
          postId: '',
          name: '',
          postImageUrl: '',
          userId: '',
          username: '',
        ),
        isDeleted: false,
      );
  @override
  List<Object> get props => [isLiked, likes, isDeleted];

  PostState copyWith({
    bool? isLiked,
    int? likes,
    PostModel? post,
    bool? isDeleted,
  }) {
    return PostState(
      isLiked: isLiked ?? this.isLiked,
      likes: likes ?? this.likes,
      post: post ?? this.post,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
