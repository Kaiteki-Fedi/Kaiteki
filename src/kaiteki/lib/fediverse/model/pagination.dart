class Pagination<TKey, TValue> {
  final List<TValue> data;
  final TKey? previous;
  final TKey? next;

  const Pagination(this.data, this.previous, this.next);
}
