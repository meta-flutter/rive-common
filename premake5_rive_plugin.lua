local dependency = require 'dependency'

harfbuzz = dependency.github('harfbuzz/harfbuzz', '6.0.0')
sheenbidi = dependency.github('Tehreer/SheenBidi', 'v2.6')
miniaudio = dependency.github('rive-app/miniaudio', 'rive')

workspace 'rive_text'
configurations {'debug', 'release'}

source = os.isdir('../../packages/runtime') and '../../packages/runtime' or 'macos/rive-cpp'

project 'rive_sheenbidi'
do
    kind 'StaticLib'
    language 'C'
    toolset 'clang'
    targetdir 'shared_lib/build/bin/%{cfg.buildcfg}/'
    objdir 'shared_lib/build/obj/%{cfg.buildcfg}/'

    includedirs {
        sheenbidi .. '/Headers'
    }

    filter {'options:arch=wasm'}
    do
        targetdir 'wasm/build/bin/%{cfg.buildcfg}/'
        objdir 'wasm/build/obj/%{cfg.buildcfg}/'
    end

    filter 'configurations:debug'
    do
        files {
            sheenbidi .. '/Source/BidiChain.c',
            sheenbidi .. '/Source/BidiTypeLookup.c',
            sheenbidi .. '/Source/BracketQueue.c',
            sheenbidi .. '/Source/GeneralCategoryLookup.c',
            sheenbidi .. '/Source/IsolatingRun.c',
            sheenbidi .. '/Source/LevelRun.c',
            sheenbidi .. '/Source/PairingLookup.c',
            sheenbidi .. '/Source/RunQueue.c',
            sheenbidi .. '/Source/SBAlgorithm.c',
            sheenbidi .. '/Source/SBBase.c',
            sheenbidi .. '/Source/SBCodepointSequence.c',
            sheenbidi .. '/Source/SBLine.c',
            sheenbidi .. '/Source/SBLog.c',
            sheenbidi .. '/Source/SBMirrorLocator.c',
            sheenbidi .. '/Source/SBParagraph.c',
            sheenbidi .. '/Source/SBScriptLocator.c',
            sheenbidi .. '/Source/ScriptLookup.c',
            sheenbidi .. '/Source/ScriptStack.c',
            sheenbidi .. '/Source/StatusStack.c'
        }
    end
    filter 'configurations:release'
    do
        files {
            sheenbidi .. '/Source/SheenBidi.c'
        }
    end

    buildoptions {
        '-Wall',
        '-ansi',
        '-pedantic',
        '-Wno-unused-function',
        '-Wno-unused-variable',
        '-DANSI_DECLARATORS'
    }

    buildoptions {
        '-fno-exceptions',
        '-fno-rtti',
        '-fno-unwind-tables'
    }

    filter {'options:arch=wasm'}
    do
        buildoptions {
            '-s STRICT=1',
            '-msimd128',
            '-s DISABLE_EXCEPTION_CATCHING=1',
            '-DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0',
            '--no-entry'
        }
    end

    filter 'configurations:debug'
    do
        defines {'DEBUG'}
        symbols 'On'
    end

    filter 'configurations:release'
    do
        defines {'RELEASE', 'NDEBUG', 'SB_CONFIG_UNITY'}
        optimize 'On'
        buildoptions {
            '-Oz',
            '-g0',
            '-flto=full'
        }

        linkoptions {
            '-Oz',
            '-g0',
            '-flto=full'
        }
    end
    filter {'system:macosx', 'options:arch=arm64'}
    do
        buildoptions {'-target arm64-apple-macos11'}
        linkoptions {'-target arm64-apple-macos11'}
    end
    filter {'system:macosx', 'options:arch=x86_64'}
    do
        buildoptions {'-target x86_64-apple-macos10.12'}
        linkoptions {'-target x86_64-apple-macos10.12'}
    end
end

project 'rive_text'
do
    kind 'SharedLib'
    language 'C++'
    cppdialect 'C++11'
    toolset 'clang'
    targetdir('shared_lib/build/bin/%{cfg.buildcfg}')
    objdir('shared_lib/build/obj/%{cfg.buildcfg}')

    dependson {
        'rive_sheenbidi'
    }

    defines {
        'WITH_RIVE_TEXT',
        'WITH_RIVE_AUDIO',
        'HAVE_OT',
        'HB_NO_FALLBACK_SHAPE',
        'HB_NO_WIN1256'
    }

    includedirs {
        source .. '/include',
        source .. '/skia/renderer/include',
        harfbuzz .. '/src/',
        sheenbidi .. '/Headers',
        miniaudio
    }

    files {
        source .. '/src/audio/audio_engine.cpp',
        source .. '/src/audio/audio_source.cpp',
        source .. '/src/audio/audio_reader.cpp',
        source .. '/src/audio/audio_sound.cpp',
        source .. '/src/renderer.cpp',
        source .. '/src/math/mat2d.cpp',
        source .. '/src/math/raw_path.cpp',
        source .. '/src/text/font_hb.cpp',
        source .. '/src/text/line_breaker.cpp',
        harfbuzz .. '/src/hb-aat-layout-ankr-table.hh',
        harfbuzz .. '/src/hb-aat-layout-bsln-table.hh',
        harfbuzz .. '/src/hb-aat-layout-common.hh',
        harfbuzz .. '/src/hb-aat-layout-feat-table.hh',
        harfbuzz .. '/src/hb-aat-layout-just-table.hh',
        harfbuzz .. '/src/hb-aat-layout-kerx-table.hh',
        harfbuzz .. '/src/hb-aat-layout-morx-table.hh',
        harfbuzz .. '/src/hb-aat-layout-opbd-table.hh',
        harfbuzz .. '/src/hb-aat-layout-trak-table.hh',
        harfbuzz .. '/src/hb-aat-layout.cc',
        harfbuzz .. '/src/hb-aat-layout.hh',
        harfbuzz .. '/src/hb-aat-ltag-table.hh',
        harfbuzz .. '/src/hb-aat-map.cc',
        harfbuzz .. '/src/hb-aat-map.hh',
        harfbuzz .. '/src/hb-aat.h',
        harfbuzz .. '/src/hb-algs.hh',
        harfbuzz .. '/src/hb-array.hh',
        harfbuzz .. '/src/hb-atomic.hh',
        harfbuzz .. '/src/hb-bimap.hh',
        harfbuzz .. '/src/hb-bit-page.hh',
        harfbuzz .. '/src/hb-bit-set-invertible.hh',
        harfbuzz .. '/src/hb-bit-set.hh',
        harfbuzz .. '/src/hb-blob.cc',
        harfbuzz .. '/src/hb-blob.hh',
        harfbuzz .. '/src/hb-buffer-deserialize-json.hh',
        harfbuzz .. '/src/hb-buffer-deserialize-text.hh',
        harfbuzz .. '/src/hb-buffer-serialize.cc',
        harfbuzz .. '/src/hb-buffer-verify.cc',
        harfbuzz .. '/src/hb-buffer.cc',
        harfbuzz .. '/src/hb-buffer.hh',
        harfbuzz .. '/src/hb-cache.hh',
        harfbuzz .. '/src/hb-cff-interp-common.hh',
        harfbuzz .. '/src/hb-cff-interp-cs-common.hh',
        harfbuzz .. '/src/hb-cff-interp-dict-common.hh',
        harfbuzz .. '/src/hb-cff1-interp-cs.hh',
        harfbuzz .. '/src/hb-cff2-interp-cs.hh',
        harfbuzz .. '/src/hb-common.cc',
        harfbuzz .. '/src/hb-config.hh',
        harfbuzz .. '/src/hb-debug.hh',
        harfbuzz .. '/src/hb-dispatch.hh',
        harfbuzz .. '/src/hb-draw.cc',
        harfbuzz .. '/src/hb-draw.h',
        harfbuzz .. '/src/hb-draw.hh',
        harfbuzz .. '/src/hb-face.cc',
        harfbuzz .. '/src/hb-face.hh',
        harfbuzz .. '/src/hb-font.cc',
        harfbuzz .. '/src/hb-font.hh',
        harfbuzz .. '/src/hb-iter.hh',
        harfbuzz .. '/src/hb-kern.hh',
        harfbuzz .. '/src/hb-machinery.hh',
        harfbuzz .. '/src/hb-map.cc',
        harfbuzz .. '/src/hb-map.hh',
        harfbuzz .. '/src/hb-meta.hh',
        harfbuzz .. '/src/hb-ms-feature-ranges.hh',
        harfbuzz .. '/src/hb-mutex.hh',
        harfbuzz .. '/src/hb-null.hh',
        harfbuzz .. '/src/hb-number-parser.hh',
        harfbuzz .. '/src/hb-number.cc',
        harfbuzz .. '/src/hb-number.hh',
        harfbuzz .. '/src/hb-object.hh',
        harfbuzz .. '/src/hb-open-file.hh',
        harfbuzz .. '/src/hb-open-type.hh',
        harfbuzz .. '/src/hb-ot-cff-common.hh',
        harfbuzz .. '/src/hb-ot-cff1-std-str.hh',
        harfbuzz .. '/src/hb-ot-cff1-table.cc',
        harfbuzz .. '/src/hb-ot-cff1-table.hh',
        harfbuzz .. '/src/hb-ot-cff2-table.cc',
        harfbuzz .. '/src/hb-ot-cff2-table.hh',
        harfbuzz .. '/src/hb-ot-cmap-table.hh',
        harfbuzz .. '/src/hb-ot-color-cbdt-table.hh',
        harfbuzz .. '/src/hb-ot-color-colr-table.hh',
        harfbuzz .. '/src/hb-ot-color-colrv1-closure.hh',
        harfbuzz .. '/src/hb-ot-color-cpal-table.hh',
        harfbuzz .. '/src/hb-ot-color-sbix-table.hh',
        harfbuzz .. '/src/hb-ot-color-svg-table.hh',
        harfbuzz .. '/src/hb-ot-color.cc',
        harfbuzz .. '/src/hb-ot-color.h',
        harfbuzz .. '/src/hb-ot-deprecated.h',
        harfbuzz .. '/src/hb-ot-face-table-list.hh',
        harfbuzz .. '/src/hb-ot-face.cc',
        harfbuzz .. '/src/hb-ot-face.hh',
        harfbuzz .. '/src/hb-ot-font.cc',
        harfbuzz .. '/src/hb-ot-gasp-table.hh',
        harfbuzz .. '/src/hb-ot-glyf-table.hh',
        harfbuzz .. '/src/hb-ot-hdmx-table.hh',
        harfbuzz .. '/src/hb-ot-head-table.hh',
        harfbuzz .. '/src/hb-ot-hhea-table.hh',
        harfbuzz .. '/src/hb-ot-hmtx-table.hh',
        harfbuzz .. '/src/hb-ot-kern-table.hh',
        harfbuzz .. '/src/hb-ot-layout-base-table.hh',
        harfbuzz .. '/src/hb-ot-layout-common.hh',
        harfbuzz .. '/src/hb-ot-layout-gdef-table.hh',
        harfbuzz .. '/src/hb-ot-layout-gpos-table.hh',
        harfbuzz .. '/src/hb-ot-layout-gsub-table.hh',
        harfbuzz .. '/src/hb-ot-layout-gsubgpos.hh',
        harfbuzz .. '/src/hb-ot-layout-jstf-table.hh',
        harfbuzz .. '/src/hb-ot-layout.cc',
        harfbuzz .. '/src/hb-ot-layout.hh',
        harfbuzz .. '/src/hb-ot-map.cc',
        harfbuzz .. '/src/hb-ot-map.hh',
        harfbuzz .. '/src/hb-ot-math-table.hh',
        harfbuzz .. '/src/hb-ot-math.cc',
        harfbuzz .. '/src/hb-ot-maxp-table.hh',
        harfbuzz .. '/src/hb-ot-meta-table.hh',
        harfbuzz .. '/src/hb-ot-meta.cc',
        harfbuzz .. '/src/hb-ot-meta.h',
        harfbuzz .. '/src/hb-ot-metrics.cc',
        harfbuzz .. '/src/hb-ot-metrics.hh',
        harfbuzz .. '/src/hb-ot-name-language-static.hh',
        harfbuzz .. '/src/hb-ot-name-language.hh',
        harfbuzz .. '/src/hb-ot-name-table.hh',
        harfbuzz .. '/src/hb-ot-name.cc',
        harfbuzz .. '/src/hb-ot-name.h',
        harfbuzz .. '/src/hb-ot-os2-table.hh',
        harfbuzz .. '/src/hb-ot-os2-unicode-ranges.hh',
        harfbuzz .. '/src/hb-ot-post-macroman.hh',
        harfbuzz .. '/src/hb-ot-post-table-v2subset.hh',
        harfbuzz .. '/src/hb-ot-post-table.hh',
        harfbuzz .. '/src/hb-ot-shaper-arabic-fallback.hh',
        harfbuzz .. '/src/hb-ot-shaper-arabic-joining-list.hh',
        harfbuzz .. '/src/hb-ot-shaper-arabic-pua.hh',
        harfbuzz .. '/src/hb-ot-shaper-arabic-table.hh',
        harfbuzz .. '/src/hb-ot-shaper-arabic-win1256.hh',
        harfbuzz .. '/src/hb-ot-shaper-arabic.cc',
        harfbuzz .. '/src/hb-ot-shaper-arabic.hh',
        harfbuzz .. '/src/hb-ot-shaper-default.cc',
        harfbuzz .. '/src/hb-ot-shaper-hangul.cc',
        harfbuzz .. '/src/hb-ot-shaper-hebrew.cc',
        harfbuzz .. '/src/hb-ot-shaper-indic-table.cc',
        harfbuzz .. '/src/hb-ot-shaper-indic.cc',
        harfbuzz .. '/src/hb-ot-shaper-indic.hh',
        harfbuzz .. '/src/hb-ot-shaper-khmer.cc',
        harfbuzz .. '/src/hb-ot-shaper-myanmar.cc',
        harfbuzz .. '/src/hb-ot-shaper-syllabic.cc',
        harfbuzz .. '/src/hb-ot-shaper-syllabic.hh',
        harfbuzz .. '/src/hb-ot-shaper-thai.cc',
        harfbuzz .. '/src/hb-ot-shaper-use-table.hh',
        harfbuzz .. '/src/hb-ot-shaper-use.cc',
        harfbuzz .. '/src/hb-ot-shaper-vowel-constraints.cc',
        harfbuzz .. '/src/hb-ot-shaper-vowel-constraints.hh',
        harfbuzz .. '/src/hb-ot-shaper.hh',
        harfbuzz .. '/src/hb-ot-shaper-indic-machine.hh',
        harfbuzz .. '/src/hb-ot-shaper-khmer-machine.hh',
        harfbuzz .. '/src/hb-ot-shaper-myanmar-machine.hh',
        harfbuzz .. '/src/hb-ot-shaper-use-machine.hh',
        harfbuzz .. '/src/hb-ot-shape-fallback.cc',
        harfbuzz .. '/src/hb-ot-shape-fallback.hh',
        harfbuzz .. '/src/hb-ot-shape-normalize.cc',
        harfbuzz .. '/src/hb-ot-shape-normalize.hh',
        harfbuzz .. '/src/hb-ot-shape.cc',
        harfbuzz .. '/src/hb-ot-shape.hh',
        harfbuzz .. '/src/hb-ot-stat-table.hh',
        harfbuzz .. '/src/hb-ot-tag-table.hh',
        harfbuzz .. '/src/hb-ot-tag.cc',
        harfbuzz .. '/src/hb-ot-var-avar-table.hh',
        harfbuzz .. '/src/hb-ot-var-common.hh',
        harfbuzz .. '/src/hb-ot-var-fvar-table.hh',
        harfbuzz .. '/src/hb-ot-var-gvar-table.hh',
        harfbuzz .. '/src/hb-ot-var-hvar-table.hh',
        harfbuzz .. '/src/hb-ot-var-mvar-table.hh',
        harfbuzz .. '/src/hb-ot-var.cc',
        harfbuzz .. '/src/hb-ot-vorg-table.hh',
        harfbuzz .. '/src/hb-pool.hh',
        harfbuzz .. '/src/hb-priority-queue.hh',
        harfbuzz .. '/src/hb-repacker.hh',
        harfbuzz .. '/src/hb-sanitize.hh',
        harfbuzz .. '/src/hb-serialize.hh',
        harfbuzz .. '/src/hb-set-digest.hh',
        harfbuzz .. '/src/hb-set.cc',
        harfbuzz .. '/src/hb-set.hh',
        harfbuzz .. '/src/hb-shape-plan.cc',
        harfbuzz .. '/src/hb-shape-plan.hh',
        harfbuzz .. '/src/hb-shape.cc',
        harfbuzz .. '/src/hb-shaper-impl.hh',
        harfbuzz .. '/src/hb-shaper-list.hh',
        harfbuzz .. '/src/hb-shaper.cc',
        harfbuzz .. '/src/hb-shaper.hh',
        harfbuzz .. '/src/hb-static.cc',
        harfbuzz .. '/src/hb-string-array.hh',
        harfbuzz .. '/src/hb-subset-cff-common.cc',
        harfbuzz .. '/src/hb-subset-cff-common.hh',
        harfbuzz .. '/src/hb-subset-cff1.cc',
        harfbuzz .. '/src/hb-subset-cff1.hh',
        harfbuzz .. '/src/hb-subset-cff2.cc',
        harfbuzz .. '/src/hb-subset-cff2.hh',
        harfbuzz .. '/src/hb-subset-input.cc',
        harfbuzz .. '/src/hb-subset-input.hh',
        harfbuzz .. '/src/hb-subset-plan.cc',
        harfbuzz .. '/src/hb-subset-plan.hh',
        harfbuzz .. '/src/hb-subset-repacker.cc',
        harfbuzz .. '/src/hb-subset-repacker.h',
        harfbuzz .. '/src/hb-subset.cc',
        harfbuzz .. '/src/hb-subset.hh',
        harfbuzz .. '/src/hb-ucd-table.hh',
        harfbuzz .. '/src/hb-ucd.cc',
        harfbuzz .. '/src/hb-unicode-emoji-table.hh',
        harfbuzz .. '/src/hb-unicode.cc',
        harfbuzz .. '/src/hb-unicode.hh',
        harfbuzz .. '/src/hb-utf.hh',
        harfbuzz .. '/src/hb-vector.hh',
        harfbuzz .. '/src/hb.hh',
        harfbuzz .. '/src/graph/gsubgpos-context.cc'
    }

    links {
        'rive_sheenbidi'
    }

    buildoptions {
        '-fno-exceptions',
        '-fno-rtti',
        '-fno-unwind-tables',
        '-DANSI_DECLARATORS'
    }

    filter {'not options:arch=wasm'}
    do
        files {
            'macos/rive_text/rive_text.cpp',
            'macos/common.cpp'
        }
    end

    filter {'options:arch=wasm'}
    do
        targetdir 'wasm/build/bin/%{cfg.buildcfg}/'
        objdir 'wasm/build/obj/%{cfg.buildcfg}/'
        kind 'ConsoleApp'
        includedirs {
            'taffy_ffi/src/'
        }
        files {
            'wasm/rive_text_bindings.cpp',
            'wasm/rive_taffy_bindings.cpp',
            'wasm/rive_audio_wasm_bindings.cpp'
        }
        defines {
            'MA_NO_RUNTIME_LINKING'
        }
        buildoptions {
            '-s STRICT=1',
            '-s DISABLE_EXCEPTION_CATCHING=1',
            '-DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0',
            '--no-entry'
        }
        libdirs {
            'taffy_ffi/target/wasm32-unknown-emscripten/minimize'
        }
        links {
            'taffy_ffi'
        }
        linkoptions {
            '--closure=1',
            '-s WASM_BIGINT',
            '--closure-args="--externs ./wasm/js/externs.js"',
            '-lembind',
            '-s FORCE_FILESYSTEM=0',
            '-s MODULARIZE=1',
            '-s NO_EXIT_RUNTIME=1',
            '-s STRICT=1',
            '-s INCOMING_MODULE_JS_API=onRuntimeInitialized',
            '-s ALLOW_MEMORY_GROWTH=1',
            '-s DISABLE_EXCEPTION_CATCHING=1',
            '-s WASM=1',
            '-s USE_ES6_IMPORT_META=0',
            '-s EXPORT_NAME="RiveText"',
            '-DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0',
            '--no-entry',
            '--pre-js ./wasm/js/rive_text.js'
        }
    end

    linkoptions {
        '-fno-exceptions',
        '-fno-rtti',
        '-fno-unwind-tables'
    }

    filter {'options:arch=wasm', 'options:use_threads'}
    do
        buildoptions {
            '-pthread'
        }
        linkoptions {
            '-pthread',
            '-sPTHREAD_POOL_SIZE=6'
        }
    end

    filter {'options:arch=wasm', 'options:single_file'}
    do
        linkoptions {
            '-o %{cfg.targetdir}/rive_text_single.js',
            '-s SINGLE_FILE=1'
        }
    end

    filter {'options:arch=wasm', 'options:not single_file'}
    do
        linkoptions {
            '-o %{cfg.targetdir}/rive_text.js'
        }
    end

    filter 'configurations:debug'
    do
        defines {'DEBUG'}
        symbols 'On'
    end

    filter {'configurations:debug', 'options:arch=wasm'}
    do
        linkoptions {'-s ASSERTIONS=1'}
    end

    filter 'configurations:release'
    do
        defines {'RELEASE'}
        defines {'NDEBUG'}
        optimize 'On'

        buildoptions {
            '-Oz',
            '-g0',
            '-flto=full'
        }

        linkoptions {
            '-Oz',
            '-g0',
            '-flto=full'
        }
    end

    filter {'configurations:release', 'options:arch=wasm'}
    do
        linkoptions {'-s ASSERTIONS=0', '--closure-args="--externs ./wasm/js/externs_release.js"'}
    end

    filter {'system:macosx', 'options:arch=arm64'}
    do
        buildoptions {'-target arm64-apple-macos11'}
        linkoptions {'-target arm64-apple-macos11'}
    end
    filter {'system:macosx', 'options:arch=x86_64'}
    do
        buildoptions {'-target x86_64-apple-macos10.12'}
        linkoptions {'-target x86_64-apple-macos10.12'}
    end
end

newoption {
    trigger = 'single_file',
    description = 'Set when the wasm should be packed in with the js code.'
}

newoption {
    trigger = 'use_threads',
    description = 'Whether to use threads for audio decoding.'
}

newoption {
    trigger = 'arch',
    description = 'Architectures we can target',
    allowed = {{'x86_64'}, {'arm64'}, {'wasm'}}
}
