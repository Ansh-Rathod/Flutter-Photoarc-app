import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingProfileAppBar extends StatelessWidget {
  const LoadingProfileAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.blueGrey.shade900,
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
            backgroundColor: Colors.black87,
            largeTitle: const Text(
              "LOADING..",
              style: TextStyle(
                fontFamily: 'EuclidTriangle',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
