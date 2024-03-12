cmake_minimum_required(VERSION 3.4.1) # for example

set(CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} -DWITH_RIVE_TEXT -DWITH_RIVE_AUDIO -DHAVE_OT -DHB_NO_FALLBACK_SHAPE -DHB_NO_WIN1256 -DHB_NO_EXTERN_HELPERS  -DYOGA_EXPORT= -std=c++11"
)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSB_CONFIG_UNITY")

add_library(
  rive_text
  # Sets the library as a shared library.
  SHARED
  # Provides a relative path to your source file(s).
  ../ios/rive_text/rive_text.cpp
  ../ios/rive-cpp/src/math/raw_path.cpp
  ../ios/rive-cpp/src/math/mat2d.cpp
  ../ios/rive-cpp/src/renderer.cpp
  ../ios/rive-cpp/src/text/font_hb.cpp
  ../ios/rive-cpp/src/text/line_breaker.cpp
  ../ios/rive-cpp/src/audio/audio_engine.cpp
  ../ios/rive-cpp/src/audio/audio_source.cpp
  ../ios/rive-cpp/src/audio/audio_sound.cpp
  ../ios/rive-cpp/src/audio/audio_reader.cpp
  ../ios/harfbuzz/src/hb-aat-layout.cc
  ../ios/harfbuzz/src/hb-aat-map.cc
  ../ios/harfbuzz/src/hb-blob.cc
  ../ios/harfbuzz/src/hb-buffer-serialize.cc
  ../ios/harfbuzz/src/hb-buffer-verify.cc
  ../ios/harfbuzz/src/hb-buffer.cc
  ../ios/harfbuzz/src/hb-common.cc
  ../ios/harfbuzz/src/hb-draw.cc
  ../ios/harfbuzz/src/hb-face.cc
  ../ios/harfbuzz/src/hb-font.cc
  ../ios/harfbuzz/src/hb-map.cc
  ../ios/harfbuzz/src/hb-number.cc
  ../ios/harfbuzz/src/hb-ot-cff1-table.cc
  ../ios/harfbuzz/src/hb-ot-cff2-table.cc
  ../ios/harfbuzz/src/hb-ot-color.cc
  ../ios/harfbuzz/src/hb-ot-face.cc
  ../ios/harfbuzz/src/hb-ot-font.cc
  ../ios/harfbuzz/src/hb-ot-layout.cc
  ../ios/harfbuzz/src/hb-ot-map.cc
  ../ios/harfbuzz/src/hb-ot-math.cc
  ../ios/harfbuzz/src/hb-ot-meta.cc
  ../ios/harfbuzz/src/hb-ot-metrics.cc
  ../ios/harfbuzz/src/hb-ot-name.cc
  ../ios/harfbuzz/src/hb-ot-shaper-arabic.cc
  ../ios/harfbuzz/src/hb-ot-shaper-default.cc
  ../ios/harfbuzz/src/hb-ot-shaper-hangul.cc
  ../ios/harfbuzz/src/hb-ot-shaper-hebrew.cc
  ../ios/harfbuzz/src/hb-ot-shaper-indic-table.cc
  ../ios/harfbuzz/src/hb-ot-shaper-indic.cc
  ../ios/harfbuzz/src/hb-ot-shaper-khmer.cc
  ../ios/harfbuzz/src/hb-ot-shaper-myanmar.cc
  ../ios/harfbuzz/src/hb-ot-shaper-syllabic.cc
  ../ios/harfbuzz/src/hb-ot-shaper-thai.cc
  ../ios/harfbuzz/src/hb-ot-shaper-use.cc
  ../ios/harfbuzz/src/hb-ot-shaper-vowel-constraints.cc
  ../ios/harfbuzz/src/hb-ot-shape-fallback.cc
  ../ios/harfbuzz/src/hb-ot-shape-normalize.cc
  ../ios/harfbuzz/src/hb-ot-shape.cc
  ../ios/harfbuzz/src/hb-ot-tag.cc
  ../ios/harfbuzz/src/hb-ot-var.cc
  ../ios/harfbuzz/src/hb-set.cc
  ../ios/harfbuzz/src/hb-shape-plan.cc
  ../ios/harfbuzz/src/hb-shape.cc
  ../ios/harfbuzz/src/hb-shaper.cc
  ../ios/harfbuzz/src/hb-static.cc
  ../ios/harfbuzz/src/hb-subset-cff-common.cc
  ../ios/harfbuzz/src/hb-subset-cff1.cc
  ../ios/harfbuzz/src/hb-subset-cff2.cc
  ../ios/harfbuzz/src/hb-subset-input.cc
  ../ios/harfbuzz/src/hb-subset-plan.cc
  ../ios/harfbuzz/src/hb-subset-repacker.cc
  ../ios/harfbuzz/src/hb-subset.cc
  ../ios/harfbuzz/src/hb-ucd.cc
  ../ios/harfbuzz/src/hb-unicode.cc
  ../ios/harfbuzz/src/graph/gsubgpos-context.cc
  ../ios/harfbuzz/src/hb-paint.cc
  ../ios/harfbuzz/src/hb-paint-extents.cc
  ../ios/harfbuzz/src/hb-outline.cc
  ../ios/harfbuzz/src/hb-subset-instancer-solver.cc
  ../ios/harfbuzz/src/hb-face-builder.cc
  ../ios/SheenBidi/Source/SheenBidi.c
  ../ios/common.cpp
  ../ios/yoga/yoga/Utils.cpp
  ../ios/yoga/yoga/YGConfig.cpp
  ../ios/yoga/yoga/YGLayout.cpp
  ../ios/yoga/yoga/YGEnums.cpp
  ../ios/yoga/yoga/YGNodePrint.cpp
  ../ios/yoga/yoga/YGNode.cpp
  ../ios/yoga/yoga/YGValue.cpp
  ../ios/yoga/yoga/YGStyle.cpp
  ../ios/yoga/yoga/Yoga.cpp
  ../ios/yoga/yoga/event/event.cpp
  ../ios/yoga/yoga/log.cpp)

target_include_directories(
  rive_text PRIVATE ../ios/harfbuzz/src ../ios/rive-cpp/skia/renderer/include
                    ../ios/rive-cpp/include ../ios/SheenBidi/Headers ../ios/miniaudio ../ios/yoga)
target_link_libraries(rive_text -llog)

