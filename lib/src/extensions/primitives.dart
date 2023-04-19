extension AsExtension on Object? {
  X as<X>() => this as X;

  X? asOrNull<X>() {
    var currObject = this;
    return currObject is X ? currObject : null;
  }

  X asOrDefault<X>(X defaultValue) {
    var currObject = this;
    return currObject.asOrNull() ?? defaultValue;
  }
}

extension Precision on num {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));

  bool isBetween(num from, num to) {
    return from < this && this < to;
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

  List<T?> withNullableItems() => whereType<T?>().toList();

  void forEachIndexed(void Function(int index, T item) action) {
    for (var index = 0; index < length; index++) {
      action(index, this[index]);
    }
  }

  List<K> fastMap<K>(K Function(T t) convertTo) {
    List<K> mappedList = List.empty(growable: true);

    for (var i = 0; i < length; i++) {
      mappedList.add(convertTo(this[i]));
    }
    return mappedList;
  }
}

extension ContainsKey<K, V> on Map<K, V> {
  V? getOrNull(K key) {
    if (containsKey(key)) return this[key];
    return null;
  }

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
