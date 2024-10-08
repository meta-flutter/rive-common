# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "rive_common")

project(${PROJECT_NAME} LANGUAGES CXX C)

# This value is used when generating builds using this plugin, so it must not be
# changed
set(PLUGIN_NAME "rive_common_plugin")

set(CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} -DNOMINMAX -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-undef -Wno-unsafe-buffer-usage -Wno-deprecated-copy-with-user-provided-dtor -Wno-documentation -Wno-documentation-pedantic -Wno-documentation-unknown-command -Wno-double-promotion -Wno-exit-time-destructors -Wno-float-equal -Wno-global-constructors -Wno-implicit-float-conversion -Wno-newline-eof -Wno-old-style-cast -Wno-reserved-identifier -Wno-shadow -Wno-sign-compare -Wno-sign-conversion -Wno-unused-function -Wno-unused-macros -Wno-unused-variable -Wno-unused-parameter -Wno-switch-enum -Wno-missing-field-initializers -DWITH_RIVE_TEXT -DWITH_RIVE_AUDIO_TOOLS -DWITH_RIVE_AUDIO -DMA_NO_RESOURCE_MANAGER -DHAVE_OT  -DHB_NO_FALLBACK_SHAPE  -DHB_NO_WIN1256  -DHB_NO_EXTERN_HELPERS -DHB_NO_BUFFER_VERIFY -DHB_NO_BUFFER_MESSAGE -DHB_NO_PAINT -DHB_NO_MMAP -DHB_NO_META -DSB_CONFIG_UNITY -Wno-tautological-constant-out-of-range-compare -D_CRT_SECURE_NO_WARNINGS -DYOGA_EXPORT="
)

set(CMAKE_C_FLAGS
    "${CMAKE_C_FLAGS} -DNOMINMAX -DSB_CONFIG_UNITY -Wno-unused-function -Wno-undef -Wno-unused-variable -Wno-unused-parameter -Wno-unsafe-buffer-usage -Wno-tautological-constant-out-of-range-compare  -D_CRT_SECURE_NO_WARNINGS"
)

# Any new source files that you add to the plugin should be added here.
list(
  APPEND
  PLUGIN_SOURCES
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

# Define the plugin library target. Its name must not be changed (see comment on
# PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED ${PLUGIN_SOURCES} "rive_plugin.cpp")

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES VS_PLATFORM_TOOLSET ClangCL
                                                CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(
  ${PLUGIN_NAME}
  INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include"
  PRIVATE ../ios/harfbuzz/src ../ios/rive-cpp/skia/renderer/include
          ../ios/rive-cpp/include ../ios/SheenBidi/Headers ../ios/miniaudio ../ios/yoga)
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin ws2_32 bcrypt ntdll kernel32 advapi32 userenv)
target_compile_features(${PLUGIN_NAME} PRIVATE cxx_std_11)