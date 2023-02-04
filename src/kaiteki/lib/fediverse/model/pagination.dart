class Pagination<K, V> {
  final V data;
  final K? previous;
  final K? next;

  const Pagination(this.data, this.previous, this.next);
}

class PaginatedList<K, V> extends Pagination<K, List<V>> {
  const PaginatedList(super.data, super.previous, super.next);
}

class PaginatedSet<K, V> extends Pagination<K, Set<V>> {
  const PaginatedSet(super.data, super.previous, super.next);
}
