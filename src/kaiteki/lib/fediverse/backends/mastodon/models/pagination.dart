class MastodonPagination<T> {
  final T data;
  final Uri? next;
  final Uri? previous;

  const MastodonPagination(this.data, this.next, this.previous);
}
