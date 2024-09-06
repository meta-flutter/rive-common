#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>
#include <stdint.h>
#include "rive/audio/audio_engine.hpp"
#include "rive/audio/audio_reader.hpp"
#include "rive/audio/audio_sound.hpp"
#include "rive/audio/audio_source.hpp"
#ifdef __EMSCRIPTEN_PTHREADS__
#include "../common_source/audio_decode_worker.hpp"
#endif

#include <stdio.h>
#include <cstdint>

using namespace emscripten;

using WasmPtr = uint32_t;
#ifdef __EMSCRIPTEN_PTHREADS__
rive::AudioDecodeWorker g_decodeWorker;
bool rive::AudioDecodeWorker::sm_exiting = false;
#endif

WasmPtr makeAudioEngine(uint32_t numChannels, uint32_t sampleRate)
{
    return (WasmPtr)rive::AudioEngine::Make(numChannels, sampleRate).release();
}

uint32_t engineTime(WasmPtr enginePtr)
{
    rive::AudioEngine* engine = (rive::AudioEngine*)enginePtr;
    if (engine == nullptr)
    {
        return 0;
    }
    return engine->timeInFrames();
}

void engineInitLevelMonitor(WasmPtr enginePtr)
{
    rive::AudioEngine* engine = (rive::AudioEngine*)enginePtr;
    if (engine == nullptr)
    {
        return;
    }
    engine->initLevelMonitor();
}

float engineLevel(WasmPtr enginePtr, uint32_t channel)
{
    rive::AudioEngine* engine = (rive::AudioEngine*)enginePtr;
    if (engine == nullptr)
    {
        return 0.0f;
    }
    return engine->level(channel);
}

uint32_t audioSourceNumChannels(WasmPtr sourcePtr)
{
    rive::AudioSource* source = (rive::AudioSource*)sourcePtr;
    if (source == nullptr)
    {
        return 0;
    }
    return source->channels();
}

uint32_t audioSourceSampleRate(WasmPtr sourcePtr)
{
    rive::AudioSource* source = (rive::AudioSource*)sourcePtr;
    if (source == nullptr)
    {
        return 0;
    }
    return source->sampleRate();
}

uint32_t audioSourceFormat(WasmPtr sourcePtr)
{
    rive::AudioSource* source = (rive::AudioSource*)sourcePtr;
    if (source == nullptr)
    {
        return 0;
    }
    return (uint32_t)source->format();
}

uint32_t numChannels(WasmPtr enginePtr)
{
    rive::AudioEngine* engine = (rive::AudioEngine*)enginePtr;
    if (engine == nullptr)
    {
        return 0;
    }
    return engine->channels();
}

uint32_t sampleRate(WasmPtr enginePtr)
{
    rive::AudioEngine* engine = (rive::AudioEngine*)enginePtr;
    if (engine == nullptr)
    {
        return 0;
    }
    return engine->sampleRate();
}

void unrefAudioEngine(WasmPtr enginePtr)
{
    rive::AudioEngine* engine = (rive::AudioEngine*)enginePtr;
    if (engine == nullptr)
    {
        return;
    }
    engine->unref();
}

WasmPtr makeAudioSourceBuffer(uint32_t byteSize)
{
    return (WasmPtr) new rive::SimpleArray<uint8_t>((size_t)byteSize);
}

WasmPtr simpleArrayData(WasmPtr simpleArrayPtr)
{
    rive::SimpleArray<uint8_t>* simpleArray = (rive::SimpleArray<uint8_t>*)simpleArrayPtr;
    if (simpleArray == nullptr)
    {
        return 0;
    }
    return (WasmPtr)simpleArray->data();
}

#ifdef DEBUG
uint32_t simpleArraySize(WasmPtr simpleArrayPtr)
{
    rive::SimpleArray<uint8_t>* simpleArray = (rive::SimpleArray<uint8_t>*)simpleArrayPtr;
    if (simpleArray == nullptr)
    {
        return 0;
    }
    return (uint32_t)simpleArray->size();
}
#endif

WasmPtr makeAudioSource(WasmPtr sourceBytesPtr)
{
    rive::SimpleArray<uint8_t>* sourceBytes = (rive::SimpleArray<uint8_t>*)sourceBytesPtr;
    if (sourceBytes == nullptr)
    {
        return (WasmPtr) nullptr;
    }

    return (WasmPtr) new rive::AudioSource(*sourceBytes);
}

struct SamplesSpan
{
    WasmPtr data;
    uint32_t count;
};

#ifdef __EMSCRIPTEN_PTHREADS__
WasmPtr makeAudioReader(WasmPtr sourcePtr, uint32_t channels, uint32_t sampleRate)
{
    rive::AudioSource* source = (rive::AudioSource*)sourcePtr;
    if (source == nullptr)
    {
        return (WasmPtr) nullptr;
    }

    auto reader = source->makeReader(channels, sampleRate);
    if (reader == nullptr)
    {
        return (WasmPtr) nullptr;
    }

    return (WasmPtr)g_decodeWorker.add(reader).release();
}

SamplesSpan audioReaderRead(WasmPtr workPtr)
{
    rive::DecodeWork* decodeWork = (rive::DecodeWork*)workPtr;
    if (decodeWork == nullptr || !decodeWork->isDone())
    {
        return {(WasmPtr) nullptr, 0};
    }

    auto frames = decodeWork->frames();
    return {(WasmPtr)frames.data(), (uint32_t)frames.count()};
}
#else
// No pthread support so we'll fake it...
namespace rive
{
class DecodeWork : public RefCnt<DecodeWork>
{
public:
    DecodeWork(rcp<AudioReader> audioReader) :
        m_audioReader(std::move(audioReader)), m_lengthInFrames(0)
    {}

    AudioReader* audioReader() { return m_audioReader.get(); }
    std::vector<float>& frames() { return m_frames; }
    uint64_t lengthInFrames() { return m_lengthInFrames; }
    void lengthInFrames(uint64_t value) { m_lengthInFrames = value; }

private:
    rcp<AudioReader> m_audioReader;
    std::vector<float> m_frames;
    uint64_t m_lengthInFrames;
};
} // namespace rive

WasmPtr makeAudioReader(WasmPtr sourcePtr, uint32_t channels, uint32_t sampleRate)
{
    rive::AudioSource* source = (rive::AudioSource*)sourcePtr;
    if (source == nullptr)
    {
        return (WasmPtr) nullptr;
    }

    auto reader = source->makeReader(channels, sampleRate);
    if (reader == nullptr)
    {
        return (WasmPtr) nullptr;
    }

    return (WasmPtr) new rive::DecodeWork(reader);
}

SamplesSpan audioReaderRead(WasmPtr workPtr)
{
    rive::DecodeWork* decodeWork = (rive::DecodeWork*)workPtr;
    if (decodeWork == nullptr)
    {
        return {(WasmPtr) nullptr, 0};
    }
    auto reader = decodeWork->audioReader();
    // 1 second at a time?
    auto readSize = (int)reader->sampleRate();
    auto readSpan = decodeWork->audioReader()->read(readSize);
    std::vector<float>& frames = decodeWork->frames();
    frames.insert(frames.end(), readSpan.begin(), readSpan.end());
    if (readSpan.size() == readSize * reader->channels())
    {
        // Not done yet.
        return {(WasmPtr) nullptr, 0};
    }
    // done.
    decodeWork->lengthInFrames((uint64_t)(frames.size() / reader->channels()));
    return {(WasmPtr)frames.data(), (uint32_t)frames.size()};
}

#endif

WasmPtr makeBufferedAudioSource(WasmPtr decodeWorkPtr, uint32_t channels, uint32_t sampleRate)
{
    rive::DecodeWork* decodeWork = (rive::DecodeWork*)decodeWorkPtr;
    if (decodeWork == nullptr)
    {
        return (WasmPtr) nullptr;
    }
    return (WasmPtr) new rive::AudioSource(decodeWork->frames(), channels, sampleRate);
}

SamplesSpan bufferedAudioSamples(WasmPtr audioSourcePtr)
{
    rive::AudioSource* audioSource = (rive::AudioSource*)audioSourcePtr;
    if (audioSource == nullptr)
    {
        return {(WasmPtr) nullptr, 0};
    }
    auto samples = audioSource->bufferedSamples();
    return {(WasmPtr)samples.data(), samples.size()};
}

void unrefAudioReader(WasmPtr decodeWorkPtr)
{
    rive::DecodeWork* decodeWork = (rive::DecodeWork*)decodeWorkPtr;
    if (decodeWork != nullptr)
    {
        decodeWork->unref();
    }
}

void unrefAudioSource(WasmPtr sourcePtr)
{
    rive::AudioSource* audioSource = (rive::AudioSource*)sourcePtr;
    if (audioSource != nullptr)
    {
        audioSource->unref();
    }
}

void stopAudioSound(WasmPtr soundPtr, uint32_t fadeTimeInFrames)
{
    rive::AudioSound* sound = (rive::AudioSound*)soundPtr;
    if (sound == nullptr)
    {
        return;
    }
    sound->stop(fadeTimeInFrames);
}

float getSoundVolume(WasmPtr soundPtr)
{
    rive::AudioSound* sound = (rive::AudioSound*)soundPtr;
    if (sound == nullptr)
    {
        return 0.0f;
    }
    return sound->volume();
}

bool getSoundCompleted(WasmPtr soundPtr)
{
    rive::AudioSound* sound = (rive::AudioSound*)soundPtr;
    if (sound == nullptr)
    {
        return true;
    }
    return sound->completed();
}

void setSoundVolume(WasmPtr soundPtr, float volume)
{
    rive::AudioSound* sound = (rive::AudioSound*)soundPtr;
    if (sound == nullptr)
    {
        return;
    }
    sound->volume(volume);
}

void unrefAudioSound(WasmPtr soundPtr)
{
    rive::AudioSound* sound = (rive::AudioSound*)soundPtr;
    if (sound == nullptr)
    {
        return;
    }
    sound->unref();
}

WasmPtr playAudioSource(WasmPtr sourcePtr,
                        WasmPtr enginePtr,
                        uint32_t engineStartTime,
                        uint32_t engineEndTime,
                        uint32_t soundStartTime)
{
    rive::AudioEngine* engine = (rive::AudioEngine*)enginePtr;
    if (engine == nullptr)
    {
        return (WasmPtr) nullptr;
    }
    rive::AudioSource* audioSource = (rive::AudioSource*)sourcePtr;
    if (audioSource == nullptr)
    {
        return (WasmPtr) nullptr;
    }

    rive::rcp<rive::AudioSource> rcAudioSource = rive::rcp<rive::AudioSource>(audioSource);
    rcAudioSource->ref();

    return (WasmPtr)engine->play(rcAudioSource, engineStartTime, engineEndTime, soundStartTime)
        .release();
}

EMSCRIPTEN_BINDINGS(RiveAudio)
{
    value_object<SamplesSpan>("SamplesSpan")
        .field("data", &SamplesSpan::data)
        .field("count", &SamplesSpan::count);

    function("makeAudioEngine", &makeAudioEngine);
    function("engineTime", &engineTime);
    function("engineInitLevelMonitor", &engineInitLevelMonitor);
    function("engineLevel", &engineLevel);
    function("numChannels", &numChannels);
    function("sampleRate", &sampleRate);
    function("audioSourceNumChannels", &audioSourceNumChannels);
    function("audioSourceSampleRate", &audioSourceSampleRate);
    function("audioSourceFormat", &audioSourceFormat);
    function("unrefAudioEngine", &unrefAudioEngine);
    function("makeBufferedAudioSource", &makeBufferedAudioSource);
    function("bufferedAudioSamples", &bufferedAudioSamples);
    function("makeAudioSourceBuffer", &makeAudioSourceBuffer);
    function("makeAudioSource", &makeAudioSource);
    function("simpleArrayData", &simpleArrayData);
#ifdef DEBUG
    function("simpleArraySize", &simpleArraySize);
#endif
    function("makeAudioReader", &makeAudioReader);
    function("unrefAudioSource", &unrefAudioSource);
    function("unrefAudioReader", &unrefAudioReader);
    function("playAudioSource", &playAudioSource);
    function("audioReaderRead", &audioReaderRead);
    function("stopAudioSound", &stopAudioSound);
    function("getSoundVolume", &getSoundVolume);
    function("getSoundCompleted", &getSoundCompleted);
    function("setSoundVolume", &setSoundVolume);
    function("unrefAudioSound", &unrefAudioSound);
}