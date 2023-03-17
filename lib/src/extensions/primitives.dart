extension ListTransforms<T> on List<T> {
  T get(int index, T defaultValue) {
    if (index >= length) {
      return defaultValue;
    } else {
      return this[index];
    }
  }

  T? getOrNull(int index) {
    if (index >= length) {
      return null;
    } else {
      return this[index];
    }
  }
}
