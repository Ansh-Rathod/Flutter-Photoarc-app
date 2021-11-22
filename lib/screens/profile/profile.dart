import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../animation.dart';
import '../add_post/add_post.dart';

import 'bloc/getposts_bloc.dart';
import 'widgets/cubit/event_button_cubit.dart';
import '../settings/setting.dart';
import '../../widgets/inital_post.dart';
import '../../widgets/loading/loading_profile.dart';

import '../../models/user_model.dart';
import 'widgets/row.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel currentUser;
  final String? id;
  const ProfileScreen({
    Key? key,
    required this.currentUser,
    this.id,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetProfileBloc()..add(GetUsesrPostsEvent(uid: widget.id!)),
      child: BlocBuilder<GetProfileBloc, GetProfileState>(
        builder: (context, state) {
          if (state is GetProfileLoaded) {
            return BlocProvider(
              create: (context) => EventButtonCubit()
                ..init(
                  currentProfile: state.user,
                  user: widget.currentUser,
                  followersCount: state.user.followersCount,
                  followingCount: state.user.followingCount,
                  postsCount: state.user.postsCount,
                  currentProfileId: widget.id!,
                ),
              child: Scaffold(
                body: RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<GetProfileBloc>(context)
                        .add(GetUsesrPostsEvent(uid: widget.id!));
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      CupertinoSliverNavigationBar(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade700,
                            width: .5,
                          ),
                        ),
                        stretch: true,
                        trailing: state.user.id == widget.currentUser.id
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CupertinoButton(
                                    child: const Icon(
                                      CupertinoIcons.camera,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        createRoute(
                                          AddPost(currentUser: state.user),
                                        ),
                                      );
                                    },
                                  ),
                                  CupertinoButton(
                                    child: const Icon(
                                      CupertinoIcons.settings,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(context,
                                          createRoute(const Settings()));
                                    },
                                  ),
                                ],
                              )
                            : null,
                        backgroundColor: Colors.black87,
                        largeTitle: Text(
                          state.user.name,
                          style: const TextStyle(
                            fontFamily: 'EuclidTriangle',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: const [
                                RowInfo(),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            thickness: .2,
                            height: .5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      if (state.posts.isEmpty)
                        SliverToBoxAdapter(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * .4,
                              child: Center(
                                child: Text(
                                  "No posts yet".toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(fontSize: 24),
                                ),
                              )),
                        )
                      else
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              children: [
                                for (var i = 0; i < state.posts.length; i++)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          createRoute(
                                            PostsWidget(
                                              inialIndex: i,
                                              currentUser: widget.currentUser,
                                              posts: state.posts,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: state.posts[i].postImageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .8,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state is GetProfileLoading) {
            return const LoadingProfile();
          } else if (state is GetProfileError) {
            return Scaffold(
                body: Center(
              child: Text(
                "Something went wrong",
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: 24,
                    ),
              ),
            ));
          } else {
            return const Scaffold(
              body: Center(
                child: Text("",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )),
              ),
            );
          }
        },
      ),
    );
  }
}
