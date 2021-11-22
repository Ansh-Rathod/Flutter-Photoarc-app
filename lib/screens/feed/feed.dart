import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/screens/add_post/add_post.dart';

import '../../animation.dart';
import '../../models/user_model.dart';
import 'bloc/feed_bloc.dart';
import '../profile/profile.dart';
import '../show-shared-post/show_shared_post.dart';
import '../../widgets/loading/feed_loading.dart';
import '../../widgets/loading/search_page_loading.dart';
import '../../widgets/post/post_widget.dart';
import '../../widgets/user_profile.dart';

class FeedScreen extends StatefulWidget {
  final UserModel currentUser;
  const FeedScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    initDynamicLinks(context);
    super.initState();
  }

  initDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (deepLink.queryParameters['type'] == 'up') {
        Navigator.push(
          context,
          createRoute(
            ProfileScreen(
              id: deepLink.queryParameters['userId']!,
              currentUser: widget.currentUser,
            ),
          ),
        );
      } else if (deepLink.queryParameters['type'] == 'post') {
        Navigator.push(
          context,
          createRoute(
            ShowSharedPost(
              userId: deepLink.queryParameters['post_user_id']!,
              postId: deepLink.queryParameters['post_id']!,
              currentUser: widget.currentUser,
            ),
          ),
        );
      } else {
        //do nothing
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FeedBloc()..add(LoadFeed(userId: widget.currentUser.id)),
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<FeedBloc, FeedState>(
            builder: (context, state) {
              if (state is FeedLoading) {
                if (widget.currentUser.followingCount == 0) {
                  return CustomScrollView(
                    slivers: [
                      CupertinoSliverNavigationBar(
                        trailing: CupertinoButton(
                          child: const Icon(
                            CupertinoIcons.camera,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                              context,
                              createRoute(
                                AddPost(currentUser: widget.currentUser),
                              ),
                            );
                          },
                        ),
                        border: Border(
                          bottom: BorderSide(
                            width: .4,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        largeTitle: const Text(
                          "Photoarc",
                          style: TextStyle(
                            fontFamily: "YatraOne",
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.black.withOpacity(.8),
                      ),
                      const SliverToBoxAdapter(child: LoadingList()),
                    ],
                  );
                }
                return CustomScrollView(
                  slivers: [
                    CupertinoSliverNavigationBar(
                      border: Border(
                        bottom: BorderSide(
                          width: .4,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      largeTitle: const Text(
                        "Photoarc",
                        style: TextStyle(
                          fontFamily: "YatraOne",
                          color: Colors.white,
                        ),
                      ),
                      trailing: CupertinoButton(
                        child: const Icon(
                          CupertinoIcons.camera,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                            context,
                            createRoute(
                              AddPost(currentUser: widget.currentUser),
                            ),
                          );
                        },
                      ),
                      backgroundColor: Colors.black.withOpacity(.8),
                    ),
                    const SliverToBoxAdapter(child: FeedLoadingWidget()),
                  ],
                );
              }
              if (state is FeedLoaded) {
                if (state.posts.isEmpty) {
                  return CustomScrollView(
                    slivers: [
                      CupertinoSliverNavigationBar(
                        border: Border(
                          bottom: BorderSide(
                            width: .4,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        trailing: CupertinoButton(
                          child: const Icon(
                            CupertinoIcons.camera,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                              context,
                              createRoute(
                                AddPost(currentUser: widget.currentUser),
                              ),
                            );
                          },
                        ),
                        largeTitle: const Text(
                          "Photoarc",
                          style: TextStyle(
                            fontFamily: "YatraOne",
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.black.withOpacity(.8),
                      ),
                      SliverToBoxAdapter(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Suggested users to follow",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                            ),
                            Divider(
                              height: .5,
                              color: Colors.grey.shade900,
                            ),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => Divider(
                                height: .5,
                                color: Colors.grey.shade800,
                              ),
                              shrinkWrap: true,
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      createRoute(
                                        ProfileScreen(
                                          currentUser: widget.currentUser,
                                          id: state.users[index].id,
                                        ),
                                      ),
                                    );
                                  },
                                  contentPadding: const EdgeInsets.all(8),
                                  leading: UserProfile(
                                    url: state.users[index].avatarUrl,
                                    size: 50,
                                  ),
                                  title: Text(
                                    state.users[index].name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                          fontSize: 20,
                                        ),
                                  ),
                                  subtitle: Text(state.users[index].username,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: Colors.grey.shade400,
                                          )),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                return CustomScrollView(
                  slivers: [
                    CupertinoSliverNavigationBar(
                      border: Border(
                        bottom: BorderSide(
                          width: .4,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      trailing: CupertinoButton(
                        child: const Icon(
                          CupertinoIcons.camera,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                            context,
                            createRoute(
                              AddPost(currentUser: widget.currentUser),
                            ),
                          );
                        },
                      ),
                      backgroundColor: Colors.black.withOpacity(.92),
                      largeTitle: const Text(
                        "Photoarc",
                        style: TextStyle(
                          fontFamily: "YatraOne",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          final post = state.posts[index];
                          return PostWidget(
                            post: post,
                            currentUser: widget.currentUser,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              if (state is FeedError) {
                return Center(
                  child: Text(
                    "Something went wrong",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 24,
                        ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
