extension NullableExtensions<T> on T? {
  S? nullTransform<S>(S Function(T object) function) {
    final value = this;
    if (value == null) return null;
    return function.call(value);
  }

  S? safeCast<S>() {
    final value = this;
    if (value is S) return value;
    return null;
  }
}