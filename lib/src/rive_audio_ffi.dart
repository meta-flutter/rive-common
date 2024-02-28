import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:rive_common/platform.dart' as rive;
import 'package:rive_common/rive_audio.dart';

final DynamicLibrary nativeLib = _loadLibrary();

DynamicLibrary _loadLibrary() {
  if (rive.Platform.instance.isTesting) {
    var paths = [
      '',
      '../../packages/rive_common/',
    ];
    if (Platform.isMacOS) {
      for (final path in paths) {
        try {
          return DynamicLibrary.open(
            '${path}shared_lib/build/bin/debug/librive_text.dylib',
          );

          // ignore: avoid_catching_errors
        } on ArgumentError catch (_) {}
      }
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('librive_text.so');
    }
  }

  if (Platform.isAndroid) {
    return DynamicLibrary.open('librive_text.so');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('rive_common_plugin.dll');
  }
  return DynamicLibrary.process();
}

final Pointer<Void> Function(
  int numChannels,
  int sampleRate,
) makeAudioEngine = nativeLib
    .lookup<
        NativeFunction<
            Pointer<Void> Function(
              Uint32,
              Uint32,
            )>>('makeAudioEngine')
    .asFunction();

final int Function(
  Pointer<Void> engine,
) engineTime = nativeLib
    .lookup<
        NativeFunction<
            Uint64 Function(
              Pointer<Void>,
            )>>('engineTime')
    .asFunction();

final int Function(
  Pointer<Void> engine,
) engineNumChannels = nativeLib
    .lookup<
        NativeFunction<
            Uint32 Function(
              Pointer<Void>,
            )>>('numChannels')
    .asFunction();

final int Function(
  Pointer<Void> engine,
) engineSampleRate = nativeLib
    .lookup<
        NativeFunction<
            Uint32 Function(
              Pointer<Void>,
            )>>('sampleRate')
    .asFunction();

final int Function(
  Pointer<Void> engine,
) audioSourceNumChannels = nativeLib
    .lookup<
        NativeFunction<
            Uint32 Function(
              Pointer<Void>,
            )>>('audioSourceNumChannels')
    .asFunction();

final int Function(
  Pointer<Void> engine,
) audioSourceSampleRate = nativeLib
    .lookup<
        NativeFunction<
            Uint32 Function(
              Pointer<Void>,
            )>>('audioSourceSampleRate')
    .asFunction();

final int Function(
  Pointer<Void> engine,
) audioSourceFormat = nativeLib
    .lookup<
        NativeFunction<
            Uint32 Function(
              Pointer<Void>,
            )>>('audioSourceFormat')
    .asFunction();

final void Function(
  Pointer<Void> engine,
) unrefAudioEngine = nativeLib
    .lookup<
        NativeFunction<
            Void Function(
              Pointer<Void>,
            )>>('unrefAudioEngine')
    .asFunction();

final void Function(
  Pointer<Void> engine,
) unrefAudioSound = nativeLib
    .lookup<
        NativeFunction<
            Void Function(
              Pointer<Void>,
            )>>('unrefAudioSound')
    .asFunction();

final Pointer<SimpleUint8Array> Function(
  int length,
) makeAudioSourceBuffer = nativeLib
    .lookup<
        NativeFunction<
            Pointer<SimpleUint8Array> Function(
              Uint64,
            )>>('makeAudioSourceBuffer')
    .asFunction();

final Pointer<Void> Function(
  Pointer<SimpleUint8Array>,
) makeAudioSource = nativeLib
    .lookup<
        NativeFunction<
            Pointer<Void> Function(
              Pointer<SimpleUint8Array>,
            )>>('makeAudioSource')
    .asFunction();

final Pointer<Void> Function(
  Pointer<Void> nativeAudioSource,
  Pointer<Void> engine,
  int,
  int,
  int,
) playAudioSource = nativeLib
    .lookup<
        NativeFunction<
            Pointer<Void> Function(
              Pointer<Void>,
              Pointer<Void>,
              Uint64,
              Uint64,
              Uint64,
            )>>('playAudioSource')
    .asFunction();

final void Function(
  Pointer<Void>,
  int,
) stopAudioSound = nativeLib
    .lookup<
        NativeFunction<
            Void Function(
              Pointer<Void>,
              Uint64,
            )>>('stopAudioSound')
    .asFunction();

final void Function(
  Pointer<Void> nativeAudioSource,
) unrefAudioSource = nativeLib
    .lookup<
        NativeFunction<
            Void Function(
              Pointer<Void>,
            )>>('unrefAudioSource')
    .asFunction();

final Pointer<Void> Function(
  Pointer<Void> source,
  int,
  int,
) makeAudioReader = nativeLib
    .lookup<
        NativeFunction<
            Pointer<Void> Function(
              Pointer<Void>,
              Uint32,
              Uint32,
            )>>('makeAudioReader')
    .asFunction();

final SamplesSpan Function(
  Pointer<Void> reader,
) audioReaderRead = nativeLib
    .lookup<NativeFunction<SamplesSpan Function(Pointer<Void>)>>(
        'audioReaderRead')
    .asFunction();

final Pointer<Void> Function(
  Pointer<Void> decodeWork,
  int,
  int,
) makeBufferedAudioSource = nativeLib
    .lookup<
        NativeFunction<
            Pointer<Void> Function(
              Pointer<Void>,
              Uint32,
              Uint32,
            )>>('makeBufferedAudioSource')
    .asFunction();

final SamplesSpan Function(
  Pointer<Void> audioSource,
) bufferedAudioSamples = nativeLib
    .lookup<NativeFunction<SamplesSpan Function(Pointer<Void>)>>(
        'bufferedAudioSamples')
    .asFunction();

final void Function(
  Pointer<Void> nativeAudioSource,
) unrefAudioReader = nativeLib
    .lookup<
        NativeFunction<
            Void Function(
              Pointer<Void>,
            )>>('unrefAudioReader')
    .asFunction();

final int Function(
  Pointer<Void> nativeAudioSource,
) audioReaderLength = nativeLib
    .lookup<
        NativeFunction<
            Uint64 Function(
              Pointer<Void>,
            )>>('audioReaderLength')
    .asFunction();

AudioEngine? initAudioDevice(int channels, int sampleRate) {
  var engine = makeAudioEngine(
    channels,
    sampleRate,
  );

  if (engine == nullptr) {
    return null;
  }
  return AudioEngineFFI(
    engine,
    channels: engineNumChannels(engine),
    sampleRate: engineSampleRate(engine),
  );
}

StreamingAudioSource loadAudioSource(Uint8List bytes) {
  var buffer = makeAudioSourceBuffer(bytes.length);
  var data = buffer.ref.data;
  for (int i = 0; i < bytes.length; i++) {
    data[i] = bytes[i];
  }

  var audioSourcePointer = makeAudioSource(buffer);

  return StreamingAudioSourceFFI(audioSourcePointer);
}

class AudioSoundFFI extends AudioSound {
  Pointer<Void> nativePtr;
  int sampleRate;
  AudioSoundFFI(this.nativePtr, this.sampleRate);

  @override
  void stop({Duration fadeTime = Duration.zero}) {
    stopAudioSound(
        nativePtr, (fadeTime.inMicroseconds * 1e-6 * sampleRate).round());
  }

  @override
  void dispose() {
    unrefAudioSound(nativePtr);
    nativePtr = nullptr;
  }
}

class AudioEngineFFI extends AudioEngine {
  Pointer<Void> nativePtr;

  static HashMap<int, AudioEngineFFI> lookup = HashMap<int, AudioEngineFFI>();

  @override
  final int channels;

  @override
  final int sampleRate;

  AudioEngineFFI(
    this.nativePtr, {
    required this.channels,
    required this.sampleRate,
  }) {
    lookup[nativePtr.address] = this;
  }

  @override
  void dispose() {
    lookup.remove(nativePtr.address);
    var p = nativePtr;
    nativePtr = nullptr;
    unrefAudioEngine(p);
  }

  @override
  int get timeInFrames => engineTime(nativePtr);

  @override
  AudioSound play(AudioSource source, int engineStartTime, int engineEndTime,
      int soundStartTime) {
    if (source is! AudioSourceFFI) {
      throw UnsupportedError('Tried to play an unsupported AudioSource.');
    }
    return AudioSoundFFI(
      playAudioSource(
        (source as AudioSourceFFI).nativePtr,
        nativePtr,
        engineStartTime,
        engineEndTime,
        soundStartTime,
      ),
      sampleRate,
    );
  }
}

class SimpleUint8Array extends Struct {
  external Pointer<Uint8> data;
  @Uint64()
  external int size;
}

class SamplesSpan extends Struct {
  external Pointer<Float> samples;
  @Uint64()
  external int sampleCount;
}

mixin AudioSourceFFI {
  Pointer<Void> get nativePtr;
  set nativePtr(Pointer<Void> value);
  int get sampleRate => audioSourceSampleRate(nativePtr);
  int get channels => audioSourceNumChannels(nativePtr);

  AudioFormat get format => AudioFormat.values[audioSourceFormat(nativePtr)];

  void dispose() {
    unrefAudioSource(nativePtr);
    nativePtr = nullptr;
  }
}

class BufferedAudioSourceFFI extends BufferedAudioSource with AudioSourceFFI {
  @override
  Pointer<Void> nativePtr;

  BufferedAudioSourceFFI(
    this.nativePtr,
    this.length,
    this.samples,
  );

  @override
  final int length;

  @override
  final Float32List samples;
}

class StreamingAudioSourceFFI extends StreamingAudioSource with AudioSourceFFI {
  @override
  Pointer<Void> nativePtr;

  @override
  int get sampleRate => audioSourceSampleRate(nativePtr);

  @override
  int get channels => audioSourceNumChannels(nativePtr);

  StreamingAudioSourceFFI(this.nativePtr);

  @override
  void dispose() {
    unrefAudioSource(nativePtr);
    nativePtr = nullptr;
  }

  @override
  Future<BufferedAudioSource> makeBuffered({int? channels, int? sampleRate}) {
    var decodeChannels = channels ?? this.channels;
    var decodeWorkPtr = makeAudioReader(
      nativePtr,
      decodeChannels,
      sampleRate ?? this.sampleRate,
    );
    final completer = Completer<BufferedAudioSource>();
    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        var samplesSpan = audioReaderRead(decodeWorkPtr);
        if (samplesSpan.samples != nullptr) {
          timer.cancel();

          var nativeBufferedSource = makeBufferedAudioSource(
            decodeWorkPtr,
            decodeChannels,
            sampleRate ?? this.sampleRate,
          );

          // Decode worker can be nuked now.
          unrefAudioReader(decodeWorkPtr);

          var samplesSpan = bufferedAudioSamples(nativeBufferedSource);

          completer.complete(
            BufferedAudioSourceFFI(
              nativeBufferedSource,
              samplesSpan.sampleCount ~/ decodeChannels,
              samplesSpan.samples.asTypedList(samplesSpan.sampleCount),
            ),
          );
        }
      },
    );
    return completer.future;
  }

  @override
  AudioFormat get format => AudioFormat.values[audioSourceFormat(nativePtr)];
}
