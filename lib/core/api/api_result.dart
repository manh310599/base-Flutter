import 'package:equatable/equatable.dart';

/// Represents the result of an API call.
/// Can be either [Success], [Error], or [NoInternet].
abstract class ApiResult<T> extends Equatable {
  const ApiResult();

  /// Creates a [Success] result with the given data.
  const factory ApiResult.success(T data) = Success<T>;

  /// Creates an [Error] result with the given error message and optional status code.
  const factory ApiResult.error(String message, {int? statusCode}) = Error<T>;

  /// Creates a [NoInternet] result.
  const factory ApiResult.noInternet() = NoInternet<T>;

  /// Transforms the result to another type using the given function.
  ApiResult<R> map<R>(R Function(T) transform);

  /// Executes the appropriate callback based on the result type.
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? statusCode) error,
    required R Function() noInternet,
  });

  /// Returns true if this result is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns true if this result is an [Error].
  bool get isError => this is Error<T>;

  /// Returns true if this result is a [NoInternet].
  bool get isNoInternet => this is NoInternet<T>;
}

/// Represents a successful API call with data.
class Success<T> extends ApiResult<T> {
  final T data;

  const Success(this.data);

  @override
  ApiResult<R> map<R>(R Function(T) transform) {
    return Success<R>(transform(data));
  }

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? statusCode) error,
    required R Function() noInternet,
  }) {
    return success(data);
  }

  @override
  List<Object?> get props => [data];
}

/// Represents a failed API call with an error message and optional status code.
class Error<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;

  const Error(this.message, {this.statusCode});

  @override
  ApiResult<R> map<R>(R Function(T) transform) {
    return Error<R>(message, statusCode: statusCode);
  }

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? statusCode) error,
    required R Function() noInternet,
  }) {
    return error(message, statusCode);
  }

  @override
  List<Object?> get props => [message, statusCode];
}

/// Represents an API call that failed due to no internet connection.
class NoInternet<T> extends ApiResult<T> {
  const NoInternet();

  @override
  ApiResult<R> map<R>(R Function(T) transform) {
    return NoInternet<R>();
  }

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? statusCode) error,
    required R Function() noInternet,
  }) {
    return noInternet();
  }

  @override
  List<Object?> get props => [];
}
