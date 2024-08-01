/// {@template commons_Errors}
/// # YunoException
/// [YunoException] has multiple variants: [YunoUnexpectedException], [YunoMethodNotImplemented],
///  [YunoTimeout], [YunoMissingParam].
///{@tool snippet}
/// ```dart
/// final YunoException error =
/// switch(error) {
///   return switch (this) {
///     YunoUnexpectedException(:String msg, :int preffix) => doSomething,
///     YunoMethodNotImplemented(:String msg, :int preffix) => doSomething,
///     YunoTimeout(:String msg, :int preffix) => doSomething,
///     YunoMissingParam(:String msg, :int preffix) => doSomething,
///   };
/// }
/// ```
/// {@end-tool}
/// {@endtemplate}
sealed class YunoException implements Exception {
  const YunoException({
    required this.msg,
    required this.preffix,
  });

  final String msg;
  final int preffix;
}


/// {@template commons_Errors}
/// # YunoUnexpectedException
/// 
/// This type of error occurs when something went wrong and the origin is unknown.
/// {@endtemplate}
class YunoUnexpectedException extends YunoException {
  YunoUnexpectedException({
     super.msg = 'Unexpected Exception',
     super.preffix = 0,
  });
}

/// {@template commons_Errors}
/// # YunoMethodNotImplemented
/// 
/// This type of error occurs when a method is not implemented.
/// {@endtemplate}
class YunoMethodNotImplemented extends YunoException {
  YunoMethodNotImplemented({
     super.msg = 'Method not implemented',
     super.preffix = 1,
  });
}

/// {@template commons_Errors}
/// # YunoTimeout
/// 
/// This type of error occurs when occurs a timeout.
/// {@endtemplate}
class YunoTimeout extends YunoException {
  YunoTimeout({
     super.msg = 'Timeout',
     super.preffix = 2,
  });
}

/// {@template commons_Errors}
/// # YunoMissingParam
/// 
/// This type of error occurs when missing one or multiple params.
/// {@endtemplate}
class YunoMissingParam extends YunoException {
  YunoMissingParam({
     super.msg = 'Missing Params',
     super.preffix = 3,
  });
}
