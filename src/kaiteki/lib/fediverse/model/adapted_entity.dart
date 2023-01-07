/// An abstract class that forces it's implementors to contain an optional
/// source field, which represents the original data model that resulted in the
/// one extending this class.
abstract class AdaptedEntity<T> {
  final T? source;

  const AdaptedEntity({required this.source});
}
