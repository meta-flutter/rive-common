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

project(rive_text
        VERSION "0.8.4"
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
string(APPEND CMAKE_C_FLAGS " -fno-exceptions -fno-unwind-tables")
string(APPEND CMAKE_C_FLAGS " -Wno-unreachable-code -ansi -pedantic -Wno-unused-function -Wno-unused-variable")

string(APPEND CMAKE_CXX_FLAGS " -fno-exceptions -fno-rtti -fno-unwind-tables")
string(APPEND CMAKE_CXX_FLAGS " -Wno-unreachable-code -Wno-unused-variable")

string(APPEND CMAKE_CXX_LINKER_FLAGS " -fno-exceptions -fno-rtti -fno-unwind-tables")

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    string(APPEND CMAKE_C_FLAGS " -Wno-documentation -Wno-comma -Wno-shorten-64-to-32")
    string(APPEND CMAKE_CXX_FLAGS " -Wno-conditional-uninitialized -Wno-documentation -Wno-comma -Wno-shorten-64-to-32")
endif ()

#
# Toolchain IPO/LTO support
#
if (ENABLE_LTO)
    cmake_policy(SET CMP0069 NEW)
    include(CheckIPOSupported)
    check_ipo_supported(
            RESULT IPO_SUPPORT_RESULT
            OUTPUT IPO_SUPPORT_OUTPUT
            LANGUAGES C CXX
    )
endif ()
if (IPO_SUPPORT_RESULT)
    message(STATUS "IPO .................... supported")
else ()
    message(STATUS "IPO .................... not supported: ${IPO_SUPPORT_OUTPUT}")
endif ()

add_library(rive_text SHARED
        macos/rive_text/rive_text.cpp
        macos/rive-cpp/src/math/raw_path.cpp
        macos/rive-cpp/src/math/mat2d.cpp
        macos/rive-cpp/src/renderer.cpp
        macos/rive-cpp/src/text/font_hb.cpp
        macos/rive-cpp/src/text/line_breaker.cpp
        macos/rive-cpp/src/audio/audio_engine.cpp
        macos/rive-cpp/src/audio/audio_source.cpp
        macos/rive-cpp/src/audio/audio_sound.cpp
        macos/rive-cpp/src/audio/audio_reader.cpp
        macos/harfbuzz/src/hb-aat-layout.cc
        macos/harfbuzz/src/hb-aat-map.cc
        macos/harfbuzz/src/hb-blob.cc
        macos/harfbuzz/src/hb-buffer-serialize.cc
        macos/harfbuzz/src/hb-buffer-verify.cc
        macos/harfbuzz/src/hb-buffer.cc
        macos/harfbuzz/src/hb-common.cc
        macos/harfbuzz/src/hb-draw.cc
        macos/harfbuzz/src/hb-face.cc
        macos/harfbuzz/src/hb-font.cc
        macos/harfbuzz/src/hb-map.cc
        macos/harfbuzz/src/hb-number.cc
        macos/harfbuzz/src/hb-ot-cff1-table.cc
        macos/harfbuzz/src/hb-ot-cff2-table.cc
        macos/harfbuzz/src/hb-ot-color.cc
        macos/harfbuzz/src/hb-ot-face.cc
        macos/harfbuzz/src/hb-ot-font.cc
        macos/harfbuzz/src/hb-ot-layout.cc
        macos/harfbuzz/src/hb-ot-map.cc
        macos/harfbuzz/src/hb-ot-math.cc
        macos/harfbuzz/src/hb-ot-meta.cc
        macos/harfbuzz/src/hb-ot-metrics.cc
        macos/harfbuzz/src/hb-ot-name.cc
        macos/harfbuzz/src/hb-ot-shaper-arabic.cc
        macos/harfbuzz/src/hb-ot-shaper-default.cc
        macos/harfbuzz/src/hb-ot-shaper-hangul.cc
        macos/harfbuzz/src/hb-ot-shaper-hebrew.cc
        macos/harfbuzz/src/hb-ot-shaper-indic-table.cc
        macos/harfbuzz/src/hb-ot-shaper-indic.cc
        macos/harfbuzz/src/hb-ot-shaper-khmer.cc
        macos/harfbuzz/src/hb-ot-shaper-myanmar.cc
        macos/harfbuzz/src/hb-ot-shaper-syllabic.cc
        macos/harfbuzz/src/hb-ot-shaper-thai.cc
        macos/harfbuzz/src/hb-ot-shaper-use.cc
        macos/harfbuzz/src/hb-ot-shaper-vowel-constraints.cc
        macos/harfbuzz/src/hb-ot-shape-fallback.cc
        macos/harfbuzz/src/hb-ot-shape-normalize.cc
        macos/harfbuzz/src/hb-ot-shape.cc
        macos/harfbuzz/src/hb-ot-tag.cc
        macos/harfbuzz/src/hb-ot-var.cc
        macos/harfbuzz/src/hb-set.cc
        macos/harfbuzz/src/hb-shape-plan.cc
        macos/harfbuzz/src/hb-shape.cc
        macos/harfbuzz/src/hb-shaper.cc
        macos/harfbuzz/src/hb-static.cc
        macos/harfbuzz/src/hb-subset-cff-common.cc
        macos/harfbuzz/src/hb-subset-cff1.cc
        macos/harfbuzz/src/hb-subset-cff2.cc
        macos/harfbuzz/src/hb-subset-input.cc
        macos/harfbuzz/src/hb-subset-plan.cc
        macos/harfbuzz/src/hb-subset-repacker.cc
        macos/harfbuzz/src/hb-subset.cc
        macos/harfbuzz/src/hb-ucd.cc
        macos/harfbuzz/src/hb-unicode.cc
        macos/harfbuzz/src/graph/gsubgpos-context.cc
        macos/harfbuzz/src/hb-paint.cc
        macos/harfbuzz/src/hb-paint-extents.cc
        macos/harfbuzz/src/hb-outline.cc
        macos/harfbuzz/src/hb-subset-instancer-solver.cc
        macos/harfbuzz/src/hb-face-builder.cc
        macos/SheenBidi/Source/SheenBidi.c
        macos/common.cpp
        macos/yoga/yoga/Utils.cpp
        macos/yoga/yoga/YGConfig.cpp
        macos/yoga/yoga/YGLayout.cpp
        macos/yoga/yoga/YGEnums.cpp
        macos/yoga/yoga/YGNodePrint.cpp
        macos/yoga/yoga/YGNode.cpp
        macos/yoga/yoga/YGValue.cpp
        macos/yoga/yoga/YGStyle.cpp
        macos/yoga/yoga/Yoga.cpp
        macos/yoga/yoga/event/event.cpp
        macos/yoga/yoga/log.cpp
)

set_target_properties(rive_text PROPERTIES
        SOVERSION "${PROJECT_VERSION}"
)

target_compile_definitions(rive_text PRIVATE
        YOGA_EXPORT=
        SB_CONFIG_UNITY
        WITH_RIVE_TEXT
        WITH_RIVE_AUDIO_TOOLS
        WITH_RIVE_AUDIO
        MA_NO_RESOURCE_MANAGER
        HAVE_OT
        HB_NO_FALLBACK_SHAPE
        HB_NO_WIN1256
 #       HB_NO_CFF
        HB_NO_BUFFER_VERIFY
        HB_NO_BUFFER_MESSAGE
        HB_NO_PAINT
        HB_NO_MMAP
        HB_NO_META
        ANSI_DECLARATORS
)

if (IPO_SUPPORT_RESULT)
    set_property(TARGET rive_text PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
endif ()

target_include_directories(rive_text PUBLIC
        macos/harfbuzz/src
        macos/rive-cpp/skia/renderer/include
        macos/rive-cpp/include
        macos/SheenBidi/Headers
        macos/miniaudio
        macos/yoga
)

configure_file(rive_text.pc.in rive_text.pc @ONLY)

install(TARGETS rive_text DESTINATION lib)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/rive_text.pc DESTINATION lib/pkgconfig)