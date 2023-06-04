import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:http/http.dart' show MultipartFile;

sealed class KaitekiFile {
  const KaitekiFile();

  FutureOr<MultipartFile> toMultipartFile(String field);

  Stream<List<int>> toStream();
}

class KaitekiMemoryFile extends KaitekiFile {
  final String? name;
  final Uint8List bytes;
  int get size => bytes.length;

  const KaitekiMemoryFile(this.bytes, {this.name});

  @override
  MultipartFile toMultipartFile(String field) {
    return MultipartFile.fromBytes(field, bytes, filename: name);
  }

  @override
  Stream<List<int>> toStream() => Stream.fromIterable([bytes]);
}

class KaitekiLocalFile extends KaitekiFile {
  final String path;
  String get name => io.File(path).uri.pathSegments.last;

  const KaitekiLocalFile(this.path);

  io.File toDartFile() => io.File(path);

  @override
  Future<MultipartFile> toMultipartFile(String field) {
    return MultipartFile.fromPath(field, path, filename: name);
  }

  @override
  Stream<List<int>> toStream() => toDartFile().openRead();
}

class KaitekiStreamFile extends KaitekiFile {
  final String? name;
  final Stream<List<int>> stream;
  final int? size;

  const KaitekiStreamFile(this.stream, {this.name, this.size});

  /// If [size] is not provided, the stream will be read to determine the size.
  @override
  Future<MultipartFile> toMultipartFile(String field) async {
    final length = size ?? await stream.length;
    return MultipartFile(field, stream, length, filename: name);
  }

  @override
  Stream<List<int>> toStream() => stream;
}
