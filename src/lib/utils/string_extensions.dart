extension StringExtensions on String {
  bool get isNullOrEmpty => this == null || this.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  bool equalsIgnoreCase(String other) {
    return this?.toLowerCase() == other?.toLowerCase();
  }
}