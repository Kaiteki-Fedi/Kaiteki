class InstanceUnreachableException implements Exception {
  final message = 'The instance entered is currently unreachable';

  @override
  String toString() => message;
}
