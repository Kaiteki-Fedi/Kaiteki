extension NullableExtension<T> on T? {
  @pragma('vm:prefer-inline')
  S? andThen<S>(S Function(T value) fn) {
    final self = this;
    return self == null ? null : fn(self);
  }

  @pragma('vm:prefer-inline')
  S? safeCast<S>() {
    final value = this;
    if (value is S) return value;
    return null;
  }
}
