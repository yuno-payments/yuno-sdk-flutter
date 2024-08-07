class Injector {
  static final Injector _instance = Injector._internal();
  factory Injector() => _instance;
  Injector._internal();

  final Map<Type, List<_DependencyEntry>> _dependencies = {};

  void registerSingleton<T>(T instance) {
    _dependencies
        .putIfAbsent(T, () => [])
        .add(_DependencyEntry.singleton(instance));
  }

  void registerLazySingleton<T>(T Function() factory) {
    _dependencies
        .putIfAbsent(T, () => [])
        .add(_DependencyEntry.lazySingleton(factory));
  }

  void registerFactory<T>(T Function() factory) {
    _dependencies
        .putIfAbsent(T, () => [])
        .add(_DependencyEntry.factory(factory));
  }

  void registerFactoryAsync<T>(Future<T> Function() factory) {
    _dependencies
        .putIfAbsent(T, () => [])
        .add(_DependencyEntry.factoryAsync(factory));
  }

  void registerSingletonIfAbsent<T>(T Function() factory) {
    if (!_dependencies.containsKey(T)) {
      _dependencies
          .putIfAbsent(T, () => [])
          .add(_DependencyEntry.singleton(factory()));
    }
  }

  void register<T>(T instance) => registerSingleton<T>(instance);

  T get<T>() {
    final entries = _dependencies[T];
    if (entries == null || entries.isEmpty) {
      throw InjectorException('No registered dependency found for type $T');
    }
    return entries.last.get() as T; // Returning the last registered instance
  }

  Future<T> getAsync<T>() async {
    final entries = _dependencies[T];
    if (entries == null || entries.isEmpty) {
      throw InjectorException(
          'No registered async dependency found for type $T');
    }
    return await entries.last.getAsync()
        as T; // Returning the last registered instance
  }

  List<T> getAll<T>() {
    final entries = _dependencies[T];
    if (entries == null) {
      return [];
    }
    return entries.map((entry) => entry.get() as T).toList();
  }

  Future<List<T>> getAllAsync<T>() async {
    final entries = _dependencies[T];
    if (entries == null) {
      return [];
    }
    final futures = entries.map((entry) => entry.getAsync());
    return (await Future.wait(futures)).cast<T>();
  }

  void unregister<T>() {
    _dependencies.remove(T);
  }

  void reset() {
    _dependencies.clear();
  }
}

class _DependencyEntry<T> {
  final _DependencyType dependencyType;
  final T Function()? _factorySync;
  final Future<T> Function()? _factoryAsync;
  T? _instance;

  _DependencyEntry.singleton(T instance)
      : dependencyType = _DependencyType.singleton,
        _instance = instance,
        _factorySync = null,
        _factoryAsync = null;

  _DependencyEntry.lazySingleton(T Function() factory)
      : dependencyType = _DependencyType.lazySingleton,
        _factorySync = factory,
        _factoryAsync = null;

  _DependencyEntry.factory(T Function() factory)
      : dependencyType = _DependencyType.factory,
        _factorySync = factory,
        _factoryAsync = null;

  _DependencyEntry.factoryAsync(Future<T> Function() factory)
      : dependencyType = _DependencyType.factoryAsync,
        _factorySync = null,
        _factoryAsync = factory;

  T get() {
    switch (dependencyType) {
      case _DependencyType.singleton:
        return _instance!;
      case _DependencyType.lazySingleton:
        _instance ??= _factorySync!();
        return _instance!;
      case _DependencyType.factory:
        return _factorySync!();
      case _DependencyType.factoryAsync:
        throw InjectorException(
            'Async dependency cannot be retrieved synchronously');
    }
  }

  Future<T> getAsync() async {
    switch (dependencyType) {
      case _DependencyType.singleton:
      case _DependencyType.lazySingleton:
      case _DependencyType.factory:
        return Future.value(get());
      case _DependencyType.factoryAsync:
        return _factoryAsync!();
    }
  }
}

enum _DependencyType {
  singleton,
  lazySingleton,
  factory,
  factoryAsync,
}

class InjectorException implements Exception {
  final String message;
  InjectorException(this.message);
  @override
  String toString() => 'InjectorException: $message';
}