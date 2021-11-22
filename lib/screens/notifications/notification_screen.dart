import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/screens/show-shared-post/show_shared_post.dart';

import '../../animation.dart';
import '../../models/user_model.dart';
import 'bloc/notifications_bloc.dart';
import '../profile/profile.dart';
import '../../widgets/inital_post.dart';
import '../../widgets/loading/search_page_loading.dart';
import '../../widgets/user_profile.dart';

class NotificationPage extends StatelessWidget {
  final UserModel currentUser;
  const NotificationPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationsBloc()..add(LoadNotifications(userId: currentUser.id)),
      child: Scaffold(body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return CustomScrollView(
              shrinkWrap: true,
              slivers: [
                CupertinoSliverNavigationBar(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade700,
                      width: .5,
                    ),
                  ),
                  stretch: true,
                  backgroundColor: Colors.transparent,
                  largeTitle: const Text(
                    "Activity",
                    style: TextStyle(
                      fontFamily: 'EuclidTriangle',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: LoadingList()),
              ],
            );
          }
          if (state is NotificationsError) {
            return const Center(
              child: Text(
                'Failed to fetch notifications',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
          if (state is NotificationsLoaded) {
            return CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  backgroundColor: Colors.black,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade700, width: 0.5),
                  ),
                  largeTitle: const Text(
                    'Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'EuclidTriangle',
                    ),
                  ),
                ),
                if (state.notifications.isEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .7,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.bell,
                              size: 100,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No notifications',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                    color: Colors.grey.shade300,
                                    fontSize: 24,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(state.notifications[index].notificationId),
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.redAccent,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onDismissed: (j) async {
                            BlocProvider.of<NotificationsBloc>(context).add(
                              DeleteNotifications(
                                userId: currentUser.id,
                                notificationId:
                                    state.notifications[index].notificationId,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      createRoute(
                                        ProfileScreen(
                                          currentUser: currentUser,
                                          id: state
                                              .notifications[index].followerId,
                                        ),
                                      ));
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                leading: UserProfile(
                                  size: 50,
                                  url: state.notifications[index].avatarUrl,
                                ),
                                title: Text(
                                  state.notifications[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        fontSize: 20,
                                      ),
                                ),
                                subtitle: Text(
                                  state.notifications[index].type == 'FOLLOW'
                                      ? 'Started following you'
                                      : 'commented on your post "' +
                                          state.notifications[index].comment +
                                          '"',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: state.notifications[index].type ==
                                        'COMMENT'
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(createRoute(ShowSharedPost(
                                            currentUser: currentUser,
                                            postId: state
                                                .notifications[index].postId,
                                            userId: currentUser.id,
                                          )));
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade900,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                state.notifications[index].model
                                                    .postImageUrl,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              Divider(
                                color: Colors.grey.shade800,
                                thickness: 0.5,
                                height: 0,
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: state.notifications.length,
                    ),
                  )
              ],
            );
          }
          return Container();
        },
      )),
    );
  }
}
