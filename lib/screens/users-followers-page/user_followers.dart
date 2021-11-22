import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../show-users-list/show_user_list.dart';
import 'cubit/get_user_followers_cubit.dart';
import '../../widgets/loading/search_page_loading.dart';

class ShowUserFollowers extends StatefulWidget {
  final UserModel currentUser;
  final String uid;
  final int index;
  const ShowUserFollowers({
    Key? key,
    required this.currentUser,
    required this.uid,
    required this.index,
  }) : super(key: key);

  @override
  State<ShowUserFollowers> createState() => _ShowUserFollowersState();
}

class _ShowUserFollowersState extends State<ShowUserFollowers> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.index,
      length: 2,
      child: BlocProvider(
        create: (context) => GetUserFollowersCubit()..init(widget.uid),
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            backgroundColor: Colors.transparent,
            middle: Text(
              widget.currentUser.name,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'EuclidTriangle',
              ),
            ),
          ),
          body: BlocBuilder<GetUserFollowersCubit, GetUserFollowersState>(
            builder: (context, state) {
              if (state.status == LoadingStauts.loading) {
                return const LoadingList();
              } else if (state.status == LoadingStauts.loaded) {
                return SafeArea(
                    child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverPersistentHeader(
                              delegate: _SliverAppBarDelegate(
                                const TabBar(
                                  indicatorColor: Colors.white,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: [
                                    Tab(text: "Followers"),
                                    Tab(text: "Following"),
                                  ],
                                ),
                              ),
                              pinned: true,
                            ),
                          ];
                        },
                        body: TabBarView(
                          children: [
                            ShowUserList(
                                currentUser: widget.currentUser,
                                users: state.followers),
                            ShowUserList(
                                currentUser: widget.currentUser,
                                users: state.followings),
                          ],
                        )));
              } else if (state.status == LoadingStauts.error) {
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
