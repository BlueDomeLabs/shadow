// lib/presentation/providers/bodily_output_providers.dart
// DI providers for bodily output domain per FLUIDS_RESTRUCTURING_SPEC.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/domain/repositories/bodily_output_repository.dart';
import 'package:shadow_app/domain/usecases/bodily_output/delete_bodily_output_use_case.dart';
import 'package:shadow_app/domain/usecases/bodily_output/get_bodily_outputs_use_case.dart';
import 'package:shadow_app/domain/usecases/bodily_output/log_bodily_output_use_case.dart';
import 'package:shadow_app/domain/usecases/bodily_output/update_bodily_output_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'bodily_output_providers.g.dart';

/// Bodily output repository provider — override in ProviderScope with
/// BodilyOutputRepositoryImpl wired to AppDatabase.bodilyOutputDao.
@Riverpod(keepAlive: true)
BodilyOutputRepository bodilyOutputRepository(Ref ref) {
  throw UnimplementedError(
    'Override bodilyOutputRepositoryProvider in ProviderScope',
  );
}

/// LogBodilyOutputUseCase provider.
@riverpod
LogBodilyOutputUseCase logBodilyOutputUseCase(Ref ref) =>
    LogBodilyOutputUseCase(
      ref.read(bodilyOutputRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// GetBodilyOutputsUseCase provider.
@riverpod
GetBodilyOutputsUseCase getBodilyOutputsUseCase(Ref ref) =>
    GetBodilyOutputsUseCase(
      ref.read(bodilyOutputRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// UpdateBodilyOutputUseCase provider.
@riverpod
UpdateBodilyOutputUseCase updateBodilyOutputUseCase(Ref ref) =>
    UpdateBodilyOutputUseCase(
      ref.read(bodilyOutputRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// DeleteBodilyOutputUseCase provider.
@riverpod
DeleteBodilyOutputUseCase deleteBodilyOutputUseCase(Ref ref) =>
    DeleteBodilyOutputUseCase(
      ref.read(bodilyOutputRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );
