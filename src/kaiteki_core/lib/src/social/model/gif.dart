import 'package:meta/meta.dart';

@immutable
class Gif {
  final Uri url;
  final Uri previewUrl;
  final String? description;

  const Gif(this.url, this.previewUrl, this.description);
}
