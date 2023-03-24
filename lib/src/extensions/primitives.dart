extension AsExtension on Object? {
  X as<X>() => this as X;

  X? asOrNull<X>() {
    var currObject = this;
    return currObject is X ? currObject : null;
  }

  X? ifNullThen<X>(X defaultValue) {
    var currObject = this;
    return currObject.asOrNull() ?? defaultValue;
  }
}

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

  List<T> distinct() => toSet().toList();

  List<Type> distinctTypes() => map((e) => e.runtimeType).toSet().toList();
}

extension ContainsKey<K, V> on Map<K, V> {
  createAndUpdate(
    K key, {
    required V Function() onCreate,
    Function(V? value)? onUpdate,
  }) {
    var isKeyPresent = containsKey(key);
    if (!isKeyPresent) {
      // Create new entry for this key
      this[key] = onCreate();
    }

    if (onUpdate != null) {
      onUpdate(this[key]);
    }
  }
}
