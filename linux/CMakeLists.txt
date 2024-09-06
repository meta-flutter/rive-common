# The Flutter tooling requires that developers have CMake 3.14 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "rive_common")
project(${PROJECT_NAME} LANGUAGES CXX C)

# This value is used when generating builds using this plugin, so it must
# not be changed.
set(PLUGIN_NAME "rive_common_plugin")

set (CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS    
"${CMAKE_CXX_FLAGS} -DYOGA_EXPORT= -DWITH_RIVE_TEXT -DWITH_RIVE_AUDIO_TOOLS -DWITH_RIVE_AUDIO -DMA_NO_RESOURCE_MANAGER -DHAVE_OT -DHB_NO_FALLBACK_SHAPE -DHB_NO_WIN1256 -DHB_NO_BUFFER_VERIFY -DHB_NO_BUFFER_MESSAGE -DHB_NO_PAINT -DHB_NO_MMAP -DHB_NO_META -Wno-conditional-uninitialized -Wno-documentation -Wno-comma -Wno-unreachable-code -Wno-shorten-64-to-32 -Wno-unused-variable -std=c++11")

set(CMAKE_C_FLAGS    "${CMAKE_C_FLAGS} -DYOGA_EXPORT= -DSB_CONFIG_UNITY -DWITH_RIVE_TEXT -DWITH_RIVE_AUDIO_TOOLS -DWITH_RIVE_AUDIO -DMA_NO_RESOURCE_MANAGER -DHAVE_OT -DHB_NO_FALLBACK_SHAPE -DHB_NO_WIN1256  -DHB_NO_CFF -DHB_NO_BUFFER_VERIFY -DHB_NO_BUFFER_MESSAGE -DHB_NO_PAINT -DHB_NO_MMAP -DHB_NO_META -Wno-documentation -Wno-comma -Wno-unreachable-code -Wno-shorten-64-to-32 -ansi -pedantic -Wno-unused-function -Wno-unused-variable -DANSI_DECLARATORS"
)

# Any new source files that you add to the plugin should be added here.
list(APPEND PLUGIN_SOURCES
  ../macos/rive_text/rive_text.cpp
  ../macos/rive-cpp/src/math/raw_path.cpp
  ../macos/rive-cpp/src/math/mat2d.cpp
  ../macos/rive-cpp/src/renderer.cpp
  ../macos/rive-cpp/src/text/font_hb.cpp
  ../macos/rive-cpp/src/text/line_breaker.cpp
  ../macos/rive-cpp/src/audio/audio_engine.cpp
  ../macos/rive-cpp/src/audio/audio_source.cpp
  ../macos/rive-cpp/src/audio/audio_sound.cpp
  ../macos/rive-cpp/src/audio/audio_reader.cpp
  ../macos/harfbuzz/src/hb-aat-layout.cc
  ../macos/harfbuzz/src/hb-aat-map.cc
  ../macos/harfbuzz/src/hb-blob.cc
  ../macos/harfbuzz/src/hb-buffer-serialize.cc
  ../macos/harfbuzz/src/hb-buffer-verify.cc
  ../macos/harfbuzz/src/hb-buffer.cc
  ../macos/harfbuzz/src/hb-common.cc
  ../macos/harfbuzz/src/hb-draw.cc
  ../macos/harfbuzz/src/hb-face.cc
  ../macos/harfbuzz/src/hb-font.cc
  ../macos/harfbuzz/src/hb-map.cc
  ../macos/harfbuzz/src/hb-number.cc
  ../macos/harfbuzz/src/hb-ot-cff1-table.cc
  ../macos/harfbuzz/src/hb-ot-cff2-table.cc
  ../macos/harfbuzz/src/hb-ot-color.cc
  ../macos/harfbuzz/src/hb-ot-face.cc
  ../macos/harfbuzz/src/hb-ot-font.cc
  ../macos/harfbuzz/src/hb-ot-layout.cc
  ../macos/harfbuzz/src/hb-ot-map.cc
  ../macos/harfbuzz/src/hb-ot-math.cc
  ../macos/harfbuzz/src/hb-ot-meta.cc
  ../macos/harfbuzz/src/hb-ot-metrics.cc
  ../macos/harfbuzz/src/hb-ot-name.cc
  ../macos/harfbuzz/src/hb-ot-shaper-arabic.cc
  ../macos/harfbuzz/src/hb-ot-shaper-default.cc
  ../macos/harfbuzz/src/hb-ot-shaper-hangul.cc
  ../macos/harfbuzz/src/hb-ot-shaper-hebrew.cc
  ../macos/harfbuzz/src/hb-ot-shaper-indic-table.cc
  ../macos/harfbuzz/src/hb-ot-shaper-indic.cc
  ../macos/harfbuzz/src/hb-ot-shaper-khmer.cc
  ../macos/harfbuzz/src/hb-ot-shaper-myanmar.cc
  ../macos/harfbuzz/src/hb-ot-shaper-syllabic.cc
  ../macos/harfbuzz/src/hb-ot-shaper-thai.cc
  ../macos/harfbuzz/src/hb-ot-shaper-use.cc
  ../macos/harfbuzz/src/hb-ot-shaper-vowel-constraints.cc
  ../macos/harfbuzz/src/hb-ot-shape-fallback.cc
  ../macos/harfbuzz/src/hb-ot-shape-normalize.cc
  ../macos/harfbuzz/src/hb-ot-shape.cc
  ../macos/harfbuzz/src/hb-ot-tag.cc
  ../macos/harfbuzz/src/hb-ot-var.cc
  ../macos/harfbuzz/src/hb-set.cc
  ../macos/harfbuzz/src/hb-shape-plan.cc
  ../macos/harfbuzz/src/hb-shape.cc
  ../macos/harfbuzz/src/hb-shaper.cc
  ../macos/harfbuzz/src/hb-static.cc
  ../macos/harfbuzz/src/hb-subset-cff-common.cc
  ../macos/harfbuzz/src/hb-subset-cff1.cc
  ../macos/harfbuzz/src/hb-subset-cff2.cc
  ../macos/harfbuzz/src/hb-subset-input.cc
  ../macos/harfbuzz/src/hb-subset-plan.cc
  ../macos/harfbuzz/src/hb-subset-repacker.cc
  ../macos/harfbuzz/src/hb-subset.cc
  ../macos/harfbuzz/src/hb-ucd.cc
  ../macos/harfbuzz/src/hb-unicode.cc
  ../macos/harfbuzz/src/graph/gsubgpos-context.cc
  ../macos/harfbuzz/src/hb-paint.cc
  ../macos/harfbuzz/src/hb-paint-extents.cc
  ../macos/harfbuzz/src/hb-outline.cc
  ../macos/harfbuzz/src/hb-subset-instancer-solver.cc
  ../macos/harfbuzz/src/hb-face-builder.cc
  ../macos/SheenBidi/Source/SheenBidi.c
  ../macos/common.cpp
  ../macos/yoga/yoga/Utils.cpp
  ../macos/yoga/yoga/YGConfig.cpp
  ../macos/yoga/yoga/YGLayout.cpp
  ../macos/yoga/yoga/YGEnums.cpp
  ../macos/yoga/yoga/YGNodePrint.cpp
  ../macos/yoga/yoga/YGNode.cpp
  ../macos/yoga/yoga/YGValue.cpp
  ../macos/yoga/yoga/YGStyle.cpp
  ../macos/yoga/yoga/Yoga.cpp
  ../macos/yoga/yoga/event/event.cpp
  ../macos/yoga/yoga/log.cpp
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED ${PLUGIN_SOURCES} "rive_plugin.cpp")

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include" 
  PRIVATE 
    ../macos/harfbuzz/src
    ../macos/rive-cpp/skia/renderer/include
    ../macos/rive-cpp/include 
    ../macos/SheenBidi/Headers 
    ../macos/miniaudio 
    ../macos/yoga
)
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(rive_common_bundled_libraries
  ""
  PARENT_SCOPE
)
