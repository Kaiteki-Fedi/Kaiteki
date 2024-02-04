import "dart:typed_data";
import "dart:ui";

Future<Image> resize(Image image, int width, int height) async {
  final codec = await instantiateImageCodec(
    await toUint8List(image, ImageByteFormat.png),
    targetWidth: width,
    targetHeight: height,
  );

  return (await codec.getNextFrame()).image;
}

Future<Uint8List> toUint8List(
  Image image, [
  ImageByteFormat format = ImageByteFormat.rawRgba,
]) async {
  final byteData = await image.toByteData(format: format);
  return byteData!.buffer.asUint8List();
}
