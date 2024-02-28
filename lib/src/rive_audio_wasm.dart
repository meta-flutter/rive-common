import 'dart:async';
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:rive_common/rive_audio.dart';

late js.JsFunction _makeAudioEngine;
late js.JsFunction _engineTime;
late js.JsFunction _numChannels;
late js.JsFunction _sampleRate;
late js.JsFunction _unrefAudioEngine;
late js.JsFunction _makeAudioSourceBuffer;
late js.JsFunction _simpleArrayData;
late js.JsFunction _makeAudioSource;
late js.JsFunction _makeAudioReader;
late js.JsFunction _audioReaderRead;
late js.JsFunction _unrefAudioSource;
late js.JsFunction _unrefAudioReader;
late js.JsFunction _playAudioSource;
late js.JsFunction _audioSourceNumChannels;
late js.JsFunction _audioSourceSampleRate;
late js.JsFunction _audioSourceFormat;
late js.JsFunction _unrefAudioSound;
late js.JsFunction _stopAudioSound;
late js.JsFunction _makeBufferedAudioSource;
late js.JsFunction _bufferedAudioSamples;

mixin AudioSourceWasm {
  int get nativePtr;
  set nativePtr(int value);
  int get sampleRate =>
      _audioSourceSampleRate.apply(<dynamic>[nativePtr]) as int;
  int get channels =>
      _audioSourceNumChannels.apply(<dynamic>[nativePtr]) as int;

  AudioFormat get format =>
      AudioFormat.values[_audioSourceFormat.apply(<dynamic>[nativePtr]) as int];

  void dispose() {
    _unrefAudioSource.apply(<dynamic>[nativePtr]);
    nativePtr = 0;
  }
}

class BufferedAudioSourceWasm extends BufferedAudioSource with AudioSourceWasm {
  @override
  int nativePtr;
  final int dataPtr;
  final int dataLength;
  BufferedAudioSourceWasm(
    this.nativePtr,
    this.dataLength,
    this.dataPtr,
  );

  @override
  int get length => dataLength ~/ channels;

  @override
  Float32List get samples =>
      AudioEngineWasm.wasmHeapFloat32(dataPtr, dataLength);
}

class StreamingAudioSourceWasm extends StreamingAudioSource
    with AudioSourceWasm {
  @override
  int nativePtr;

  StreamingAudioSourceWasm(
    this.nativePtr,
  );

  @override
  Future<BufferedAudioSource> makeBuffered({int? channels, int? sampleRate}) {
    var decodeWorkPtr = _makeAudioReader.apply(<dynamic>[
      nativePtr,
      channels ?? this.channels,
      sampleRate ?? this.sampleRate,
    ]) as int;
    final completer = Completer<BufferedAudioSource>();
    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        var obj =
            _audioReaderRead.apply(<dynamic>[decodeWorkPtr]) as js.JsObject;
        var data = obj['data'] as int;

        if (data != 0) {
          assert(data % 4 == 0);
          timer.cancel();

          var nativeBufferedSource = _makeBufferedAudioSource.apply(<dynamic>[
            decodeWorkPtr,
            channels ?? this.channels,
            sampleRate ?? this.sampleRate,
          ]) as int;

          // Decode worker can be nuked now.
          _unrefAudioReader.apply(<dynamic>[decodeWorkPtr]);

          var samplesSpan = _bufferedAudioSamples
              .apply(<dynamic>[nativeBufferedSource]) as js.JsObject;
          var samplesData = samplesSpan['data'] as int;
          var samplesCount = samplesSpan['count'] as int;
          assert(samplesData % 4 == 0);
          completer.complete(
            BufferedAudioSourceWasm(
              nativeBufferedSource,
              samplesCount,
              samplesData ~/ 4,
            ),
          );
        }
      },
    );
    return completer.future;
  }

  // @override
  // Future<AudioReader> makeReader({int? sampleRate, int? channels}) {
  //   var decodeWorkPtr = _makeAudioReader.apply(<dynamic>[
  //     nativePtr,
  //     channels ?? this.channels,
  //     sampleRate ?? this.sampleRate
  //   ]) as int;
  //   final completer = Completer<AudioReader>();
  //   Timer.periodic(
  //     const Duration(milliseconds: 10),
  //     (timer) {
  //       var obj =
  //           _audioReaderRead.apply(<dynamic>[decodeWorkPtr]) as js.JsObject;
  //       var data = obj['data'] as int;
  //       var dataCount = obj['count'] as int;

  //       if (data != 0) {
  //         assert(data % 4 == 0);

  //         timer.cancel();
  //         completer.complete(
  //           AudioReaderWasm(
  //             decodeWorkPtr,
  //             this,
  //             AudioEngineWasm.wasmHeapFloat32(data ~/ 4, dataCount),
  //           ),
  //         );
  //       }
  //     },
  //   );
  //   return completer.future;
  // }
}

class AudioSoundWasm extends AudioSound {
  int nativePtr;
  final int sampleRate;
  AudioSoundWasm(this.nativePtr, this.sampleRate);

  @override
  void stop({Duration fadeTime = Duration.zero}) {
    _stopAudioSound.apply(<dynamic>[
      nativePtr,
      (fadeTime.inMicroseconds * 1e-6 * sampleRate).round()
    ]);
  }

  @override
  void dispose() {
    _unrefAudioSound.apply(<dynamic>[nativePtr]);
    nativePtr = 0;
  }
}

class AudioEngineWasm extends AudioEngine {
  int nativePtr;
  static late js.JsObject module;

  @override
  final int channels;

  @override
  final int sampleRate;
  AudioEngineWasm(this.nativePtr,
      {required this.channels, required this.sampleRate});

  static void initWasmModule(js.JsObject module) {
    AudioEngineWasm.module = module;
    _makeAudioEngine = module['makeAudioEngine'] as js.JsFunction;
    _engineTime = module['engineTime'] as js.JsFunction;
    _audioSourceNumChannels = module['audioSourceNumChannels'] as js.JsFunction;
    _audioSourceSampleRate = module['audioSourceSampleRate'] as js.JsFunction;
    _audioSourceFormat = module['audioSourceFormat'] as js.JsFunction;
    _numChannels = module['numChannels'] as js.JsFunction;
    _sampleRate = module['sampleRate'] as js.JsFunction;
    _unrefAudioEngine = module['unrefAudioEngine'] as js.JsFunction;
    _makeAudioSourceBuffer = module['makeAudioSourceBuffer'] as js.JsFunction;
    _simpleArrayData = module['simpleArrayData'] as js.JsFunction;
    _makeAudioSource = module['makeAudioSource'] as js.JsFunction;
    _makeAudioReader = module['makeAudioReader'] as js.JsFunction;
    _audioReaderRead = module['audioReaderRead'] as js.JsFunction;
    _unrefAudioSource = module['unrefAudioSource'] as js.JsFunction;
    _unrefAudioReader = module['unrefAudioReader'] as js.JsFunction;
    _playAudioSource = module['playAudioSource'] as js.JsFunction;
    _unrefAudioSound = module['unrefAudioSound'] as js.JsFunction;
    _stopAudioSound = module['stopAudioSound'] as js.JsFunction;
    _makeBufferedAudioSource =
        module['makeBufferedAudioSource'] as js.JsFunction;
    _bufferedAudioSamples = module['bufferedAudioSamples'] as js.JsFunction;
  }

  @override
  void dispose() {
    _unrefAudioEngine.apply(<dynamic>[nativePtr]);
    nativePtr = 0;
  }

  static Uint8List wasmHeapUint8(int ptr, int length) {
    // Make sure to access HEAPU8 dynamically as the reference can change if the
    // WASM heap is resized.
    var heap = module['HEAPU8'] as Uint8List;
    return Uint8List.sublistView(heap, ptr, ptr + length);
  }

  static Float32List wasmHeapFloat32(int ptr, int length) {
    // Make sure to access HEAPF32 dynamically as the reference can change if
    // the WASM heap is resized.
    var heap = module['HEAPF32'] as Float32List;
    return Float32List.sublistView(heap, ptr, ptr + length);
  }

  @override
  int get timeInFrames => _engineTime.apply(<dynamic>[nativePtr]) as int;

  @override
  AudioSound play(AudioSource source, int engineStartTime, int engineEndTime,
      int soundStartTime) {
    if (source is! AudioSourceWasm) {
      throw UnsupportedError('Tried to play an unsupported AudioSource.');
    }
    return AudioSoundWasm(
      _playAudioSource.apply(<dynamic>[
        (source as AudioSourceWasm).nativePtr,
        nativePtr,
        engineStartTime,
        engineEndTime,
        soundStartTime,
      ]) as int,
      sampleRate,
    );
  }
}

StreamingAudioSource loadAudioSource(Uint8List bytes) {
  var simpleArrayUint8 =
      _makeAudioSourceBuffer.apply(<dynamic>[bytes.length]) as int;

  var data = AudioEngineWasm.wasmHeapUint8(
      _simpleArrayData.apply(<dynamic>[simpleArrayUint8]) as int, bytes.length);
  data.setAll(0, bytes);

  return StreamingAudioSourceWasm(
    _makeAudioSource.apply(<dynamic>[simpleArrayUint8]) as int,
  );
}

AudioEngine? initAudioDevice(int channels, int sampleRate) {
  var engine = _makeAudioEngine.apply(<dynamic>[
    channels,
    sampleRate,
  ]) as int;

  if (engine == 0) {
    return null;
  }
  return AudioEngineWasm(
    engine,
    channels: _numChannels.apply(<dynamic>[engine]) as int,
    sampleRate: _sampleRate.apply(<dynamic>[engine]) as int,
  );
}
