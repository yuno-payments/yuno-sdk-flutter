

/// {@template commons_Result}
/// # Result
/// [Result] has two variants: [Ok] and [Err]
///
/// ```
/// final Result<String, Exception> result =
/// switch(result) {
///   return switch (this) {
///     Ok(:T value) => value,
///     Err(:E err) => throw err,
///   };
/// }
/// ```
/// {@endtemplate}
///
/// {@template commons_Result_Ok}
/// ## Ok
///
/// An [Ok] can be created with a value
///
/// ```
/// final ok1 = Ok<String, Exception>('Hi');
/// final ok2 = Result<String, Exception>.ok('Hi');
/// ```
/// {@endtemplate}
///
/// {@template commons_Result_Err}
/// ## Err
///
/// An [Err] can be created with an exception
///
/// ```
/// final err1 = Result<String, Exception>.err(Exception('Unexpected'));
/// final err2 = Err<String, Exception>(Exception('Unexpected'));
/// ```
/// {@endtemplate}
sealed class Result<T extends Object, E extends Exception>
    {
  const Result._();

  /// {@macro commons_Result_Ok}
  factory Result.ok(T value) = Ok;

  /// {@macro commons_Result_Err}
  factory Result.err(E err) = Err;

  /// Unsafe operations that returns [T] or throw [E]
  T unwrap() {
    return switch (this) {
      Ok(:final T value) => value,
      Err(:final E err) => throw err,
    };
  }

  /// Unsafe operations that returns [E] or throw an [Exception]
  E unwrapErr() {
    return switch (this) {
      Ok(:final T value) => throw ResultUnwrapException<T, E>(value.toString()),
      Err(:final E err) => err,
    };
  }

  /// Maps the value from [T] to [U] if it is [Ok], else, keeps the [Err], [E].
  Result<U, E> map<U extends Object>(U Function(T) onOk) {
    return switch (this) {
      Ok(:final T value) => Ok(onOk(value)),
      Err(:final E err) => Err(err),
    };
  }

  /// Maps the error from [E] to [E2] if it is [Err], else, keeps the [Ok], [T].
  Result<T, E2> mapErr<E2 extends Exception>(E2 Function(E) onErr) {
    return switch (this) {
      Ok(:final T value) => Ok(value),
      Err(:final E err) => Err(onErr(err)),
    };
  }

  /// Returns [T] on [Ok], or `null` on [Err]
  T? unwrapOrNull() => switch (this) {
        Ok(:final T value) => value,
        Err() => null,
      };
}

/// {@macro commons_Result}
///
/// {@macro commons_Result_Ok}
class Ok<T extends Object, E extends Exception> extends Result<T, E> {
  /// {@macro commons_Result_Ok}
  Ok(this.value) : super._();

  /// Value when a Result is ok,
  final T value;

  @override
  String toString() {
    return 'Ok($value)';
  }
}

/// {@macro commons_Result}
///
/// {@macro commons_Result_Err}
class Err<T extends Object, E extends Exception> extends Result<T, E> {
  /// {@macro commons_Result_Err}
  Err(this.err) : super._();

  /// Exception in the [Result]
  final E err;

  @override
  String toString() {
    return 'Err($err)';
  }
}

/// {@template commons_result_ResultUnwrapException}
/// [Exception] thrown when unwrapping a [Result] that is [Err].
/// {@endtemplate}
class ResultUnwrapException<T, E> implements Exception {
  /// {@macro oxidized.ResultUnwrapException}
  ResultUnwrapException([String? message])
      : message = message ?? 'A Result<$T, $E>() cannot be unwrapped';

  /// The message associated with this exception.
  final String message;

  @override
  String toString() {
    return 'ResultUnwrapException: $message';
  }
}

/// Sugar syntax for Future<Result<T, E>>
typedef FutResult<T extends Object, E extends Exception> = Future<Result<T, E>>;