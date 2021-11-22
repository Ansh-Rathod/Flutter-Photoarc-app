import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../animation.dart';
import '../../models/user_model.dart';
import 'bloc/get_trending_posts_bloc.dart';
import 'cubit/get_search_results_cubit.dart';
import 'search_results.dart';
import '../../widgets/inital_post.dart';

class SearchPage extends StatelessWidget {
  final UserModel currentUser;
  const SearchPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTrendingPostsBloc()..add(LoadGetTrendingPosts()),
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Search",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(top: 5.0, bottom: 10),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                          border: InputBorder.none,
                          hintText: 'Search',
                        ),
                        onSubmitted: (String value) {
                          Navigator.push(
                            context,
                            createRoute(
                              BlocProvider(
                                create: (context) => GetSearchResultsCubit()
                                  ..getSearchResults(
                                      value.toLowerCase(), currentUser.id),
                                child: SearchResults(
                                  currentUser: currentUser,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    background: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    color: Colors.grey.shade800,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
              ];
            },
            body: BlocBuilder<GetTrendingPostsBloc, GetTrendingPostsState>(
              builder: (context, state) {
                if (state is GetTrendingPostsLoading) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.builder(
                      itemCount: 20,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 30, 34, 45),
                          highlightColor: const Color.fromARGB(255, 30, 34, 45)
                              .withOpacity(.85),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.grey.shade900,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                if (state is GetTrendingPostsLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                        ),
                        itemCount: state.posts.length,
                        itemBuilder: (context, i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  createRoute(
                                    PostsWidget(
                                      inialIndex: i,
                                      currentUser: currentUser,
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
                          );
                        }),
                  );
                }
                if (state is GetTrendingPostsError) {
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
      ),
    );
  }
}
