import 'package:flutter_test/flutter_test.dart';
import 'package:yuno_sdk_core/commons/src/injector.dart';

void main() {
  late Injector injector;

  setUp(() {
    injector = Injector();
  });

  tearDown(() {
    injector.reset();
  });

  test('registerSingleton and get', () {
    injector.registerSingleton<String>('Hello');
    expect(injector.get<String>(), equals('Hello'));
  });

  test('registerLazySingleton', () {
    int count = 0;
    injector.registerLazySingleton<int>(() {
      count++;
      return count;
    });
    expect(injector.get<int>(), equals(1));
    expect(injector.get<int>(), equals(1));
    expect(count, equals(1));
  });

  test('registerFactory', () {
    int count = 0;
    injector.registerFactory<int>(() {
      count++;
      return count;
    });
    expect(injector.get<int>(), equals(1));
    expect(injector.get<int>(), equals(2));
    expect(count, equals(2));
  });

  test('registerFactoryAsync', () async {
    injector.registerFactoryAsync<String>(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      return 'Async Value';
    });
    expect(await injector.getAsync<String>(), equals('Async Value'));
  });

  test('registerSingletonIfAbsent', () {
    injector.registerSingletonIfAbsent<int>(() => 5);
    expect(injector.get<int>(), equals(5));
    injector.registerSingletonIfAbsent<int>(() => 10);
    expect(injector.get<int>(), equals(5)); // Should still be 5
  });

  test('getAll', () {
    injector.registerSingleton<int>(1);

    injector.registerFactory<int>(() => 2);
    expect(injector.getAll<int>(), equals([1, 2]));
  });

  test('getAllAsync', () async {
    injector.registerSingleton<String>('A');
    injector.registerFactoryAsync<String>(() async => 'B');
    expect(await injector.getAllAsync<String>(), equals(['A', 'B']));
  });

  test('unregister', () {
    injector.registerSingleton<int>(10);
    expect(injector.get<int>(), equals(10));
    injector.unregister<int>();
    expect(() => injector.get<int>(), throwsA(isA<InjectorException>()));
  });

  test('error handling - get non-existent dependency', () {
    expect(() => injector.get<double>(), throwsA(isA<InjectorException>()));
  });

  test('error handling - getAsync non-existent dependency', () {
    expect(injector.getAsync<double>(), throwsA(isA<InjectorException>()));
  });

  test('register and get singleton', () {
    Injector().registerSingleton<int>(1);
    expect(Injector().get<int>(), equals(1));
  });

  test('register and get lazy singleton', () {
    var counter = 0;
    Injector().registerLazySingleton<int>(() => ++counter);
    expect(Injector().get<int>(), equals(1));
    expect(Injector().get<int>(), equals(1)); // Should still be 1
  });

  test('register and get factory', () {
    var counter = 0;
    Injector().registerFactory<int>(() => ++counter);
    expect(Injector().get<int>(), equals(1));
    expect(Injector().get<int>(), equals(2)); // Should be 2 now
  });

  test('register and get factory async', () async {
    var counter = 0;
    Injector().registerFactoryAsync<int>(() async => ++counter);
    expect(await Injector().getAsync<int>(), equals(1));
    expect(await Injector().getAsync<int>(), equals(2)); // Should be 2 now
  });

  test('get all registered instances of the same type', () {
    Injector().registerSingleton<int>(1);
    Injector().registerFactory<int>(() => 2);
    expect(Injector().getAll<int>(), equals([1, 2]));
  });

  test('register and get singleton if absent', () {
    var counter = 0;
    Injector().registerSingletonIfAbsent<int>(() => ++counter);
    expect(Injector().get<int>(), equals(1));

    // Registering again should not change the value
    Injector().registerSingletonIfAbsent<int>(() => ++counter);
    expect(Injector().get<int>(), equals(1));
  });

  test('unregister a dependency', () {
    Injector().registerSingleton<int>(1);
    expect(Injector().get<int>(), equals(1));

    Injector().unregister<int>();
    expect(() => Injector().get<int>(), throwsA(isA<InjectorException>()));
  });

  test('reset all dependencies', () {
    Injector().registerSingleton<int>(1);
    Injector().registerSingleton<String>('test');

    Injector().reset();
    expect(() => Injector().get<int>(), throwsA(isA<InjectorException>()));
    expect(() => Injector().get<String>(), throwsA(isA<InjectorException>()));
  });

  test('get async dependency synchronously throws exception', () {
    Injector().registerFactoryAsync<int>(() async => 1);
    expect(() => Injector().get<int>(), throwsA(isA<InjectorException>()));
  });

  test('getAllAsync for async dependencies', () async {
    var counter = 0;
    Injector().registerFactoryAsync<int>(() async => ++counter);
    Injector().registerFactoryAsync<int>(() async => ++counter);
    expect(await Injector().getAllAsync<int>(), equals([1, 2]));
  });

  test('throws exception when no dependency found', () {
    expect(() => Injector().get<int>(), throwsA(isA<InjectorException>()));
  });

  test('throws exception when no async dependency found', () async {
    expect(() => Injector().getAsync<int>(), throwsA(isA<InjectorException>()));
  });
}
