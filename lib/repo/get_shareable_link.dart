import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<Uri> getUrl({
  required String title,
  required String description,
  required String image,
  required String url,
}) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://anshrathod.page.link/',
    link: Uri.parse(url),
    androidParameters: AndroidParameters(
      packageName: 'com.example.android',
      minimumVersion: 125,
    ),
    googleAnalyticsParameters: GoogleAnalyticsParameters(
      campaign: 'example-promo',
      medium: 'social',
      source: 'orkut',
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: title,
      description: description,
      imageUrl: Uri.parse(image),
    ),
  );

  final Uri dynamicUrl = await parameters.buildUrl();
  final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
    dynamicUrl,
    DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
  );

  final Uri shortUrl = shortenedLink.shortUrl;
  return shortUrl;
}
