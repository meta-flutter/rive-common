#
# Copyright 2024 Joel Winarske
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

cmake_minimum_required(VERSION 3.10.2)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug, Release, RelWithDebInfo, or MinSizeRel." FORCE)
    message(STATUS "CMAKE_BUILD_TYPE not set, defaulting to Release.")
endif ()

project(rive-text
        VERSION "0.3.2"
        DESCRIPTION "Rive Text Library"
        LANGUAGES CXX C
)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

string(APPEND CMAKE_C_FLAGS " -Wall -ansi -pedantic -Wno-unused-function -Wno-unused-variable")
string(APPEND CMAKE_C_FLAGS " -fno-exceptions -fno-rtti -fno-unwind-tables")
string(APPEND CMAKE_C_FLAGS " -flto=full")
string(APPEND CMAKE_C_LINKER_FLAGS " -flto=full")

string(APPEND CMAKE_CXX_FLAGS " -fno-exceptions -fno-rtti -fno-unwind-tables")
string(APPEND CMAKE_CXX_FLAGS " -flto=full")
string(APPEND CMAKE_CXX_LINKER_FLAGS " -fno-exceptions -fno-rtti -fno-unwind-tables")
string(APPEND CMAKE_CXX_LINKER_FLAGS " -flto=full")

add_library(rive_sheenbidi STATIC
    third_party/sheenbidi/Source/BidiChain.c
    third_party/sheenbidi/Source/BidiTypeLookup.c
    third_party/sheenbidi/Source/BracketQueue.c
    third_party/sheenbidi/Source/GeneralCategoryLookup.c
    third_party/sheenbidi/Source/IsolatingRun.c
    third_party/sheenbidi/Source/LevelRun.c
    third_party/sheenbidi/Source/PairingLookup.c
    third_party/sheenbidi/Source/RunQueue.c
    third_party/sheenbidi/Source/SBAlgorithm.c
    third_party/sheenbidi/Source/SBBase.c
    third_party/sheenbidi/Source/SBCodepointSequence.c
    third_party/sheenbidi/Source/SBLine.c
    third_party/sheenbidi/Source/SBLog.c
    third_party/sheenbidi/Source/SBMirrorLocator.c
    third_party/sheenbidi/Source/SBParagraph.c
    third_party/sheenbidi/Source/SBScriptLocator.c
    third_party/sheenbidi/Source/ScriptLookup.c
    third_party/sheenbidi/Source/ScriptStack.c
    third_party/sheenbidi/Source/StatusStack.c
    third_party/sheenbidi/Source/SheenBidi.c
)

target_compile_definitions(rive_sheenbidi PRIVATE ANSI_DECLARATORS)

target_include_directories(rive_sheenbidi PUBLIC third_party/sheenbidi/Headers)

add_library(rive_text SHARED
    macos/rive-cpp/src/audio/audio_engine.cpp
    macos/rive-cpp/src/audio/audio_source.cpp
    macos/rive-cpp/src/audio/audio_reader.cpp
    macos/rive-cpp/src/audio/audio_sound.cpp
    macos/rive-cpp/src/renderer.cpp
    macos/rive-cpp/src/math/mat2d.cpp
    macos/rive-cpp/src/math/raw_path.cpp
    macos/rive-cpp/src/text/font_hb.cpp
    macos/rive-cpp/src/text/line_breaker.cpp

    macos/rive_text/rive_text.cpp
    macos/common.cpp

    #harfbuzz
    third_party/harfbuzz/src/hb-aat-layout.cc
    third_party/harfbuzz/src/hb-aat-map.cc
    third_party/harfbuzz/src/hb-blob.cc
    third_party/harfbuzz/src/hb-buffer-serialize.cc
    third_party/harfbuzz/src/hb-buffer-verify.cc
    third_party/harfbuzz/src/hb-buffer.cc
    third_party/harfbuzz/src/hb-common.cc
    third_party/harfbuzz/src/hb-draw.cc
    third_party/harfbuzz/src/hb-face.cc
    third_party/harfbuzz/src/hb-font.cc
    third_party/harfbuzz/src/hb-map.cc
    third_party/harfbuzz/src/hb-number.cc
    third_party/harfbuzz/src/hb-ot-cff1-table.cc
    third_party/harfbuzz/src/hb-ot-cff2-table.cc
    third_party/harfbuzz/src/hb-ot-color.cc
    third_party/harfbuzz/src/hb-ot-face.cc
    third_party/harfbuzz/src/hb-ot-font.cc
    third_party/harfbuzz/src/hb-ot-layout.cc
    third_party/harfbuzz/src/hb-ot-map.cc
    third_party/harfbuzz/src/hb-ot-math.cc
    third_party/harfbuzz/src/hb-ot-meta.cc
    third_party/harfbuzz/src/hb-ot-metrics.cc
    third_party/harfbuzz/src/hb-ot-name.cc
    third_party/harfbuzz/src/hb-ot-shaper-arabic.cc
    third_party/harfbuzz/src/hb-ot-shaper-default.cc
    third_party/harfbuzz/src/hb-ot-shaper-hangul.cc
    third_party/harfbuzz/src/hb-ot-shaper-hebrew.cc
    third_party/harfbuzz/src/hb-ot-shaper-indic-table.cc
    third_party/harfbuzz/src/hb-ot-shaper-indic.cc
    third_party/harfbuzz/src/hb-ot-shaper-khmer.cc
    third_party/harfbuzz/src/hb-ot-shaper-myanmar.cc
    third_party/harfbuzz/src/hb-ot-shaper-syllabic.cc
    third_party/harfbuzz/src/hb-ot-shaper-thai.cc
    third_party/harfbuzz/src/hb-ot-shaper-use.cc
    third_party/harfbuzz/src/hb-ot-shaper-vowel-constraints.cc
    third_party/harfbuzz/src/hb-ot-shape-fallback.cc
    third_party/harfbuzz/src/hb-ot-shape-normalize.cc
    third_party/harfbuzz/src/hb-ot-shape.cc
    third_party/harfbuzz/src/hb-ot-tag.cc
    third_party/harfbuzz/src/hb-ot-var.cc
    third_party/harfbuzz/src/hb-set.cc
    third_party/harfbuzz/src/hb-shape-plan.cc
    third_party/harfbuzz/src/hb-shape.cc
    third_party/harfbuzz/src/hb-shaper.cc
    third_party/harfbuzz/src/hb-static.cc
    third_party/harfbuzz/src/hb-subset-cff-common.cc
    third_party/harfbuzz/src/hb-subset-cff1.cc
    third_party/harfbuzz/src/hb-subset-cff2.cc
    third_party/harfbuzz/src/hb-subset-input.cc
    third_party/harfbuzz/src/hb-subset-plan.cc
    third_party/harfbuzz/src/hb-subset-repacker.cc
    third_party/harfbuzz/src/hb-subset.cc
    third_party/harfbuzz/src/hb-ucd.cc
    third_party/harfbuzz/src/hb-unicode.cc
    third_party/harfbuzz/src/graph/gsubgpos-context.cc
    third_party/harfbuzz/src/hb-paint.cc
    third_party/harfbuzz/src/hb-paint-extents.cc
    third_party/harfbuzz/src/hb-outline.cc
    third_party/harfbuzz/src/hb-subset-instancer-solver.cc
    third_party/harfbuzz/src/hb-face-builder.cc

    # Yoga
    third_party/yoga/yoga/log.cpp
    third_party/yoga/yoga/Utils.cpp
    third_party/yoga/yoga/YGConfig.cpp
    third_party/yoga/yoga/YGEnums.cpp
    third_party/yoga/yoga/YGLayout.cpp
    third_party/yoga/yoga/YGNode.cpp
    third_party/yoga/yoga/YGNodePrint.cpp
    third_party/yoga/yoga/YGStyle.cpp
    third_party/yoga/yoga/YGValue.cpp
    third_party/yoga/yoga/Yoga.cpp
)

set_target_properties(rive_text PROPERTIES
    SOVERSION      "${PROJECT_VERSION}"
)

target_compile_definitions(rive_text PRIVATE
    WITH_RIVE_TEXT
    WITH_RIVE_AUDIO
    HAVE_OT
    HB_NO_FALLBACK_SHAPE
    HB_NO_WIN1256
    YOGA_EXPORT=
)

target_include_directories(rive_text PUBLIC
    macos/rive-cpp/include
    macos/rive-cpp/skia/renderer/include
    third_party/harfbuzz/src
    third_party/sheebidi/Headers
    third_party/miniaudio
    third_party/yoga
)

target_link_libraries(rive_text PUBLIC rive_sheenbidi)

target_compile_definitions(rive_text PRIVATE ANSI_DECLARATORS)

install(TARGETS rive_text DESTINATION lib)
