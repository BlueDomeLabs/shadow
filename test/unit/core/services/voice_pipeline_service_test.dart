// test/unit/core/services/voice_pipeline_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/services/voice_pipeline_service.dart';
import 'package:speech_to_text/speech_to_text.dart';

@GenerateMocks([SpeechToText, FlutterTts])
import 'voice_pipeline_service_test.mocks.dart';

void main() {
  late MockSpeechToText mockStt;
  late MockFlutterTts mockTts;
  late VoicePipelineService service;

  setUp(() {
    mockStt = MockSpeechToText();
    mockTts = MockFlutterTts();
    service = VoicePipelineService.withDependencies(mockStt, mockTts);

    // Stub awaitSpeakCompletion to avoid unhandled calls
    when(mockTts.awaitSpeakCompletion(any)).thenAnswer((_) async => 1);
  });

  group('VoicePipelineService', () {
    test('hasMicPermission_returnsFalse_beforeInit', () async {
      expect(await service.hasMicPermission(), isFalse);
    });

    test('speak_callsTtsSpeak', () async {
      when(mockTts.speak(any)).thenAnswer((_) async => 1);
      await service.speak('Hello there');
      verify(mockTts.speak('Hello there')).called(1);
    });

    test('stopSpeaking_callsTtsStop', () async {
      when(mockTts.stop()).thenAnswer((_) async => 1);
      await service.stopSpeaking();
      verify(mockTts.stop()).called(1);
    });

    test('stopListening_callsSttStop', () async {
      when(mockStt.stop()).thenAnswer((_) async {});
      await service.stopListening();
      verify(mockStt.stop()).called(1);
    });

    test('activateAudioSession_noErrorOnNonIos', () async {
      // On macOS/Android (non-iOS) the guard returns before calling TTS.
      // Verify setIosAudioCategory is NOT called — no error thrown.
      await service.activateAudioSession();
      verifyNever(mockTts.setIosAudioCategory(any, any, any));
    });

    test('deactivateAudioSession_noErrorOnNonIos', () async {
      await service.deactivateAudioSession();
      verifyNever(mockTts.setIosAudioCategory(any, any, any));
    });
  });
}
