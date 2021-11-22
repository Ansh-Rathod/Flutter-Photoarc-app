import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../user_profile.dart';

class LoadingProfile extends StatelessWidget {
  const LoadingProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 30, 34, 45),
      highlightColor: const Color.fromARGB(255, 30, 34, 45).withOpacity(.85),
      child: CustomScrollView(
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
            largeTitle: Text(
              "LOADING..",
              style: TextStyle(
                fontFamily: 'EuclidTriangle',
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const LoadingTile(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: 1,
                              height: 20,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const LoadingTile(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: 1,
                              height: 20,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const LoadingTile(),
                        ],
                      ),
                    ),
                    const UserProfile(size: 70, url: ""),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 10,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 10,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: 3,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.grey.shade900,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class LoadingTile extends StatelessWidget {
  const LoadingTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "0",
          style: TextStyle(
            fontFamily: 'EuclidTriangle',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 10,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
