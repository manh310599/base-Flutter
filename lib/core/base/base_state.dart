import 'package:equatable/equatable.dart';

/// Base state class for all states in the application.
/// Contains common properties for loading, error, and data.
class BaseState<T> extends Equatable {
  final bool loading;
  final String? error;
  final T? data;

  const BaseState({
    this.loading = false,
    this.error,
    this.data,
  });

  /// Returns true if the state has data and no error.
  bool get isSuccess => data != null && error == null;

  /// Returns true if the state has an error.
  bool get hasError => error != null;

  /// Returns true if the state has data.
  bool get hasData => data != null;

  /// Creates a copy of this state with the given fields replaced.
  BaseState<T> copyWith({
    bool? loading,
    String? error,
    T? data,
  }) {
    return BaseState<T>(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  /// Creates a loading state.
  BaseState<T> asLoading() => copyWith(loading: true, error: null);

  /// Creates an error state.
  BaseState<T> asError(String errorMessage) =>
      copyWith(loading: false, error: errorMessage);

  /// Creates a success state with data.
  BaseState<T> asSuccess(T data) =>
      copyWith(loading: false, error: null, data: data);

  @override
  List<Object?> get props => [loading, error, data];
}
