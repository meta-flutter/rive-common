#include "rive/audio/audio_engine.hpp"
#include "rive/audio/audio_reader.hpp"
#include "rive/audio/audio_sound.hpp"
#include "rive/audio/audio_source.hpp"
#include "rive/audio/audio_format.hpp"
#include "rive/audio/audio_format.hpp"

#include <stdio.h>
#include <cstdint>

#if defined(_MSC_VER)
#define EXPORT extern "C" __declspec(dllexport)
#else
#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

rive::AudioDecodeWorker* g_decodeWorker;
static rive::AudioDecodeWorker* decodeWorker()
{
    if (g_decodeWorker == nullptr)
    {
        g_decodeWorker = new rive::AudioDecodeWorker();
    }
    return g_decodeWorker;
}
bool rive::AudioDecodeWorker::sm_exiting = false;

EXPORT rive::AudioEngine* makeAudioEngine(uint32_t numChannels, uint32_t sampleRate)
{
    return rive::AudioEngine::Make(numChannels, sampleRate).release();
}

EXPORT uint64_t engineTime(rive::AudioEngine* engine)
{
    if (engine == nullptr)
    {
        return 0;
    }
    return engine->timeInFrames();
}

EXPORT uint32_t numChannels(rive::AudioEngine* engine)
{
    if (engine == nullptr)
    {
        return 0;
    }
    return engine->channels();
}

EXPORT uint32_t sampleRate(rive::AudioEngine* engine)
{
    if (engine == nullptr)
    {
        return 0;
    }
    return engine->sampleRate();
}

EXPORT uint32_t audioSourceNumChannels(rive::AudioSource* source)
{
    if (source == nullptr)
    {
        return 0;
    }
    return source->channels();
}

EXPORT uint32_t audioSourceFormat(rive::AudioSource* source)
{
    if (source == nullptr)
    {
        return 0;
    }
    return (uint32_t)source->format();
}

EXPORT uint32_t audioSourceSampleRate(rive::AudioSource* source)
{
    if (source == nullptr)
    {
        return 0;
    }
    return source->sampleRate();
}

EXPORT void unrefAudioEngine(rive::AudioEngine* engine)
{
    if (engine == nullptr)
    {
        return;
    }
    engine->unref();
}

EXPORT void unrefAudioSound(rive::AudioSound* sound)
{
    if (sound == nullptr)
    {
        return;
    }
    sound->unref();
}

EXPORT rive::SimpleArray<uint8_t>* makeAudioSourceBuffer(uint64_t byteSize)
{
    return new rive::SimpleArray<uint8_t>((size_t)byteSize);
}

EXPORT rive::AudioSource* makeAudioSource(rive::SimpleArray<uint8_t>* sourceBytes)
{
    if (sourceBytes == nullptr)
    {
        return nullptr;
    }

    return new rive::AudioSource(*sourceBytes);
}

EXPORT rive::DecodeWork* makeAudioReader(rive::AudioSource* source,
                                         uint32_t channels,
                                         uint32_t sampleRate)
{
    if (source == nullptr)
    {
        return nullptr;
    }

    auto reader = source->makeReader(channels, sampleRate);
    if (reader == nullptr)
    {
        return nullptr;
    }
    return decodeWorker()->add(reader).release();
}

struct SamplesSpan
{
    float* data;
    uint64_t count;
};
EXPORT SamplesSpan audioReaderRead(rive::DecodeWork* decodeWork)
{
    if (decodeWork == nullptr || !decodeWork->isDone())
    {
        return {nullptr, 0};
    }

    auto frames = decodeWork->frames();
    return {frames.data(), (uint64_t)frames.size()};
}

EXPORT rive::AudioSource* makeBufferedAudioSource(rive::DecodeWork* decodeWork,
                                                  uint32_t channels,
                                                  uint32_t sampleRate)
{
    if (decodeWork == nullptr)
    {
        return nullptr;
    }
    return new rive::AudioSource(decodeWork->frames(), channels, sampleRate);
}

EXPORT SamplesSpan bufferedAudioSamples(rive::AudioSource* audioSource)
{
    auto samples = audioSource->bufferedSamples();
    return {samples.data(), samples.size()};
}

EXPORT void unrefAudioSource(rive::AudioSource* audioSource) { audioSource->unref(); }

EXPORT void unrefAudioReader(rive::DecodeWork* decodeWork) { decodeWork->unref(); }

EXPORT void stopAudioSound(rive::AudioSound* sound, uint64_t fadeTimeInFrames)
{
    if (sound == nullptr)
    {
        return;
    }
    sound->stop(fadeTimeInFrames);
}

EXPORT rive::AudioSound* playAudioSource(rive::AudioSource* audioSource,
                                         rive::AudioEngine* engine,
                                         uint64_t engineStartTime,
                                         uint64_t engineEndTime,
                                         uint64_t soundStartTime)
{
    rive::rcp<rive::AudioSource> rcSource = rive::rcp<rive::AudioSource>(audioSource);
    rcSource->ref();
    return engine->play(rcSource, engineStartTime, engineEndTime, soundStartTime).release();
}

EXPORT uint64_t audioReaderLength(rive::DecodeWork* decodeWork)
{
    if (decodeWork == nullptr)
    {
        return 0;
    }
    return decodeWork->lengthInFrames();
}