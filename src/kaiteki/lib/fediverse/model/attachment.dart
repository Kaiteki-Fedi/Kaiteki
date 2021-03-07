class Attachment<T> {
  final T source;

  final String previewUrl;
  final String url;
  final String description;
  final String type;

  Attachment({
    this.source,
    this.previewUrl,
    this.url,
    this.description,
    this.type,
  }); //TODO: convert to enum
}
