// test/presentation/providers/notifications/anchor_event_times_provider_test.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/usecases/notifications/get_anchor_event_times_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';
import 'package:shadow_app/domain/usecases/notifications/update_anchor_event_time_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/notifications/anchor_event_times_provider.dart';

void main() {
  group('AnchorEventTimes', () {
    List<AnchorEventTime> makeTestTimes() => AnchorEventName.values
        .map(
          (name) => AnchorEventTime(
            id: 'anchor-${name.value}',
            name: name,
            timeOfDay: name.defaultTime,
          ),
        )
        .toList();

    test('build loads all anchor event times', () async {
      final testTimes = makeTestTimes();

      final container = ProviderContainer(
        overrides: [
          getAnchorEventTimesUseCaseProvider.overrideWithValue(
            _FakeGetAnchorEventTimes(testTimes),
          ),
          updateAnchorEventTimeUseCaseProvider.overrideWithValue(
            _FakeUpdateAnchorEventTime(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(anchorEventTimesProvider.future);

      expect(result, hasLength(8));
      expect(result.first.name, AnchorEventName.wake);
    });

    test('build throws on use case failure', () async {
      final container = ProviderContainer(
        overrides: [
          getAnchorEventTimesUseCaseProvider.overrideWithValue(
            _FakeGetAnchorEventTimesError(),
          ),
          updateAnchorEventTimeUseCaseProvider.overrideWithValue(
            _FakeUpdateAnchorEventTime(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(anchorEventTimesProvider.future),
        throwsA(isA<AppError>()),
      );
    });

    test('updateAnchorEvent calls use case and refreshes', () async {
      final fakeUpdate = _FakeUpdateAnchorEventTime();
      final testTimes = makeTestTimes();

      final container = ProviderContainer(
        overrides: [
          getAnchorEventTimesUseCaseProvider.overrideWithValue(
            _FakeGetAnchorEventTimes(testTimes),
          ),
          updateAnchorEventTimeUseCaseProvider.overrideWithValue(fakeUpdate),
        ],
      );
      addTearDown(container.dispose);

      await container.read(anchorEventTimesProvider.future);

      await container
          .read(anchorEventTimesProvider.notifier)
          .updateAnchorEvent(
            const UpdateAnchorEventTimeInput(
              id: 'anchor-0',
              timeOfDay: '06:30',
            ),
          );

      expect(fakeUpdate.calledWithId, 'anchor-0');
    });
  });
}

// Fakes

class _FakeGetAnchorEventTimes implements GetAnchorEventTimesUseCase {
  final List<AnchorEventTime> _times;
  _FakeGetAnchorEventTimes(this._times);

  @override
  Future<Result<List<AnchorEventTime>, AppError>> call() async =>
      Success(_times);
}

class _FakeGetAnchorEventTimesError implements GetAnchorEventTimesUseCase {
  @override
  Future<Result<List<AnchorEventTime>, AppError>> call() async =>
      Failure(DatabaseError.queryFailed('test', Exception('db error')));
}

class _FakeUpdateAnchorEventTime implements UpdateAnchorEventTimeUseCase {
  String? calledWithId;

  @override
  Future<Result<AnchorEventTime, AppError>> call(
    UpdateAnchorEventTimeInput input,
  ) async {
    calledWithId = input.id;
    return Success(
      AnchorEventTime(
        id: input.id,
        name: AnchorEventName.wake,
        timeOfDay: input.timeOfDay ?? '07:00',
      ),
    );
  }
}
