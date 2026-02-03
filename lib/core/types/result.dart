// lib/core/types/result.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

/// Result type for handling success/failure without exceptions.
///
/// ALL repository and use case methods returning data MUST use this type.
sealed class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get valueOrNull => isSuccess ? (this as Success<T, E>).value : null;
  E? get errorOrNull => isFailure ? (this as Failure<T, E>).error : null;

  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) {
    if (this is Success<T, E>) {
      return success((this as Success<T, E>).value);
    } else {
      return failure((this as Failure<T, E>).error);
    }
  }
}

final class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

final class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}
