class MastodonPagination<T> {
  final T data;
  final Map<String, String>? previousParams;
  final Map<String, String>? nextParams;

  const MastodonPagination(this.data, this.previousParams, this.nextParams);
}
