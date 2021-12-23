import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../animation.dart';
import '../../api/extension.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../repo/get_shareable_link.dart';
import '../../screens/comments/comment.dart';
import '../../screens/post-liked-by/post_liked_by.dart';
import '../../screens/profile/profile.dart';
import '../../screens/verify-email/verify_email.dart';
import '../readmore.dart';
import '../user_profile.dart';
import 'cubit/post_cubit.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  final UserModel currentUser;

  const PostWidget({
    Key? key,
    required this.post,
    required this.currentUser,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit()..init(widget.post),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return !state.isDeleted
              ? Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(1, 30, 34, 45),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    createRoute(
                                      ProfileScreen(
                                        currentUser: widget.currentUser,
                                        id: widget.post.userId,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    UserProfile(
                                      url: widget.post.avatarUrl,
                                      size: 40,
                                    ),
                                    const SizedBox(width: 14),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.post.name,
                                          style: const TextStyle(
                                            fontFamily: 'EuclidTriangle',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            letterSpacing: 0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                            StringExtension
                                                .displayTimeAgoFromTimestamp(
                                              widget.post.createdAt,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 30, 34, 45),
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return Container(
                                        color: Colors.black26,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Container(
                                                height: 5,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              if (widget.currentUser.id ==
                                                  widget.post.userId)
                                                Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    PostCubit>(
                                                                context)
                                                            .deletePost(
                                                                widget
                                                                    .currentUser
                                                                    .id,
                                                                widget.post
                                                                    .postId);
                                                        Navigator.pop(context);
                                                      },
                                                      minLeadingWidth: 20,
                                                      leading: Icon(
                                                        CupertinoIcons.delete,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      title: Text(
                                                        "Delete Post",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: .5,
                                                      thickness: .5,
                                                      color:
                                                          Colors.grey.shade800,
                                                    )
                                                  ],
                                                ),
                                              Column(
                                                children: [
                                                  ListTile(
                                                    onTap: () async {
                                                      final url = await getUrl(
                                                        description:
                                                            state.post.caption,
                                                        image: state
                                                            .post.postImageUrl,
                                                        title:
                                                            'Check out this post by ${state.post.name}',
                                                        url:
                                                            'https://ansh-rathod-blog.netlify.app/socialapp?post_user_id=${state.post.userId}&post_id=${state.post.postId}&type=post',
                                                      );
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: url
                                                                  .toString()));
                                                      Navigator.pop(context);
                                                      showSnackBarToPage(
                                                        context,
                                                        'Copied to clipboard',
                                                        Colors.green,
                                                      );
                                                    },
                                                    minLeadingWidth: 20,
                                                    leading: Icon(
                                                      CupertinoIcons.link,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    title: Text(
                                                      "Copy URL",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: .5,
                                                    thickness: .5,
                                                    color: Colors.grey.shade800,
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  ListTile(
                                                    onTap: () {
                                                      launch(state
                                                          .post.postImageUrl);
                                                    },
                                                    minLeadingWidth: 20,
                                                    leading: Icon(
                                                      CupertinoIcons.photo,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    title: Text(
                                                      "Open Image in Brower ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: .5,
                                                    thickness: .5,
                                                    color: Colors.grey.shade800,
                                                  )
                                                ],
                                              ),
                                            ]));
                                  },
                                );
                              },
                              child: const Icon(
                                CupertinoIcons.ellipsis,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      AspectRatio(
                        aspectRatio: widget.post.width / widget.post.height,
                        child: CachedNetworkImage(
                          imageUrl: widget.post.postImageUrl,
                          placeholder: (context, url) => AspectRatio(
                            aspectRatio: widget.post.width / widget.post.height,
                            child: Shimmer.fromColors(
                              baseColor: const Color.fromARGB(255, 30, 34, 45),
                              highlightColor:
                                  const Color.fromARGB(255, 30, 34, 45)
                                      .withOpacity(.85),
                              child: Container(
                                  color: const Color.fromARGB(255, 30, 34, 45)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  createRoute(
                                    PostLikedBy(
                                      postId: widget.post.postId,
                                      currentUser: widget.currentUser,
                                      userId: widget.post.userId,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "${state.likes} likes",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final url = await getUrl(
                                      description: state.post.caption,
                                      image: state.post.postImageUrl,
                                      title:
                                          'Check out this post by ${state.post.name}',
                                      url:
                                          'https://anshrathod.vercel.app/socialapp?post_user_id=${state.post.userId}&post_id=${state.post.postId}&type=post',
                                    );
                                    Share.share(
                                        'Check out this post $url on Photoarc app',
                                        subject: 'Made in flutter with 💙');
                                  },
                                  child: const Icon(
                                    CupertinoIcons.share,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      createRoute(
                                        CommentScreen(
                                          postId: widget.post.postId,
                                          userId: widget.post.userId,
                                          currentUser: widget.currentUser,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    CupertinoIcons.bubble_middle_bottom,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<PostCubit>(context).like();
                                  },
                                  child: !state.isLiked
                                      ? const Icon(
                                          CupertinoIcons.heart,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          CupertinoIcons.heart_solid,
                                          color: Colors.red,
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (widget.post.caption != "") const SizedBox(height: 16),
                      if (widget.post.caption != "")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ReadMoreText(
                            widget.post.caption,
                            trimLines: 2,
                            style: Theme.of(context).textTheme.bodyText1,
                            colorClickableText: Theme.of(context).primaryColor,
                            trimMode: TrimMode.line,
                            trimCollapsedText: '...Show more',
                            trimExpandedText: '...Show less',
                            moreStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Your Post is Deleted But it shows in grid temporary.you have to reload your profile page.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Divider(
                      height: .4,
                      color: Colors.grey.shade800,
                    )
                  ],
                );
        },
      ),
    );
  }
}
