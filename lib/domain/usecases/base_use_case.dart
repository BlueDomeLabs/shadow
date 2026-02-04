// lib/domain/usecases/base_use_case.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.1

// ignore_for_file: one_member_abstracts

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';

/// Base class for use cases with single input and output.
abstract class UseCase<Input, Output> {
  Future<Result<Output, AppError>> call(Input input);
}

/// Base class for use cases with no input.
abstract class UseCaseNoInput<Output> {
  Future<Result<Output, AppError>> call();
}

/// Base class for use cases with no output.
abstract class UseCaseNoOutput<Input> {
  Future<Result<void, AppError>> call(Input input);
}

/// Alternate naming convention for UseCase (output, input order).
/// Used by intelligence and wearable subsystems for consistency
/// with their existing patterns. Functionally identical to UseCase.
///
/// NOTE: The type parameter order is `Output, Input` (reversed from UseCase).
abstract class UseCaseWithInput<Output, Input> {
  Future<Result<Output, AppError>> call(Input input);
}
