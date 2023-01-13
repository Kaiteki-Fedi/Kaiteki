import "package:http/http.dart" show MultipartFile;

/// A simple data compound intended for use in file transfers.
class File {
  final String? name;

  final String? path;
  final List<int>? bytes;
  final Stream<List<int>>? stream;
  final int? size;

  const File.stream(
    Stream<List<int>> this.stream,
    this.size, {
    this.name,
  })  : path = null,
        bytes = null;

  const File.path(
    String this.path, {
    this.name,
  })  : bytes = null,
        stream = null,
        size = null;

  const File.bytes(
    List<int> this.bytes, {
    this.name,
  })  : path = null,
        stream = null,
        size = null;

  Future<MultipartFile> toMultipartFile(String field) async {
    final path = this.path;
    if (path != null) {
      return MultipartFile.fromPath(field, path, filename: name);
    }

    final bytes = this.bytes;
    if (bytes != null) {
      return MultipartFile.fromBytes(field, bytes, filename: name);
    }

    final stream = this.stream;
    final size = this.size;
    if (stream != null && size != null) {
      return MultipartFile(field, stream, size, filename: name);
    }

    throw UnimplementedError();
  }
}
