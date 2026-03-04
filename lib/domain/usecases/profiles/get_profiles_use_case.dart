// lib/domain/usecases/profiles/get_profiles_use_case.dart

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/repositories/profile_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Use case to retrieve all profiles owned by this device.
///
/// Filters by ownerId = device ID so that each device sees only its own
/// profiles. This is the Phase 3 foundation for cloud-account filtering.
class GetProfilesUseCase implements UseCaseNoInput<List<Profile>> {
  final ProfileRepository _repository;
  final DeviceInfoService _deviceInfoService;

  GetProfilesUseCase(this._repository, this._deviceInfoService);

  @override
  Future<Result<List<Profile>, AppError>> call() async {
    final deviceId = await _deviceInfoService.getDeviceId();
    return _repository.getByOwner(deviceId);
  }
}
