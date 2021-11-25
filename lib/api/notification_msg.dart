String buildnotification(List<dynamic> result) {
  List<String> comments = [];
  List<String> comment = [];
  List<String> follow = [];
  List<String> likes = [];
  for (var element in result) {
    print(element['_type']);
    if (element['_type'] == 'LIKE') {
      likes.add(element['name']);
    } else if (element['_type'] == 'COMMENT') {
      comments.add(element['name']);
      comment.add(element['comment']);
    } else if (element['_type'] == 'FOLLOW') {
      follow.add(element['name']);
    }
  }

  if (comments.isNotEmpty && follow.isNotEmpty && likes.isNotEmpty) {
    return 'You have some notifications in your activity feed';
  } else if (comments.isNotEmpty && follow.isNotEmpty) {
    if (comments.length == 1 && follow.length == 1) {
      if (comments[0] == follow[0]) {
        return "${comments[0]} commented on your post '${comment[0]}' and started following you.";
      }
      return "${comments[0]} commented on your post '${comment[0]}' and ${follow[0]} started following you.";
    }
    if (comments.length == 1 && follow.length > 1) {
      return "${comments[0]} commented on your post '${comment[0]}' and ${follow.length} new followers.";
    }
    if (comments.length > 1 && follow.length == 1) {
      return "${comments.length} new comments and ${follow[0]} started following you.";
    }
    if (comments.length > 1 && follow.length > 1) {
      return "you have noticications from ${comments.length} new commenters and ${follow.length} new followers.";
    }
    return "${comments.length} new comments on your post and ${follow.length} new followers.";
  } else if (comments.isNotEmpty && likes.isNotEmpty) {
    if (comments.length == 1 && likes.length == 1) {
      if (comments[0] == likes[0]) {
        return "${comments[0]} commented on your post '${comment[0]}' and liked your post.";
      }
      return "${comments[0]} commented on your post '${comment[0]}' and ${likes[0]} liked your post.";
    }
    if (comments.length == 1 && likes.length > 1) {
      return "${comments[0]} commented on your post '${comment[0]}' and ${likes.length} new likes on your post.";
    }
    if (comments.length > 1 && likes.length == 1) {
      return "${comments.length} new comments and ${likes[0]} liked your post.";
    }
    if (comments.length > 1 && likes.length > 1) {
      return "${comments.length} new comments and ${likes.length} new likes on your post.";
    }
    return "You have ${comments.length} new comments and ${likes.length} likes on your posts.";
  } else if (comments.isNotEmpty) {
    if (comments.length == 1) {
      return "${comments[0]} commented on your post '${comment[0]}'";
    }
    if (comments.length == 2) {
      return "${comments[0]} and ${comments[1]} commented on your post.";
    }
    if (comments.length == 3) {
      return "${comments[0]}, ${comments[1]} and ${comments[2]} commented on your post.";
    }
    return "${comments.length} new comments on you post.";
  } else if (likes.isNotEmpty) {
    if (likes.length == 1) {
      return "${likes[0]} liked your post.";
    }
    if (likes.length == 2) {
      return "${likes[0]} and ${likes[1]} liked your post.";
    }
    if (likes.length == 3) {
      return "${likes[0]}, ${likes[1]} and ${likes[2]} liked your post.";
    }
    return "${likes.length} people liked your post.";
  } else if (follow.isNotEmpty) {
    if (follow.length == 1) {
      return "${follow[0]} followed you.";
    }
    if (follow.length == 2) {
      return "${follow[0]} and ${follow[1]} followed you.";
    }
    if (follow.length == 3) {
      return "${follow[0]}, ${follow[1]} and ${follow[2]} followed you.";
    }
    return "${follow.length} new people started following you.";
  } else {
    return "You have some notifications in your activity feed.";
  }
}
