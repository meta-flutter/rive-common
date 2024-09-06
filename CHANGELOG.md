## 0.4.11

- Update Android `minSdkVersion` from 16 to 19
- Update `kotlin_version` from '1.6.10' to '1.7.10'
- Specify the Android NDK version Rive should use by setting `rive.ndk.version` in `gradle.properties`. For example: `rive.ndk.version=26.3.11579264`. See issue [398](https://github.com/rive-app/rive-flutter/issues/398).
- Expand supported `web` package range to `web: ">=0.5.1 <2.0.0"`. Resolves issues [413](https://github.com/rive-app/rive-flutter/issues/413) and [415](https://github.com/rive-app/rive-flutter/issues/415).
- Fix iOS audio issue, see [416](https://github.com/rive-app/rive-flutter/issues/416)

## 0.4.10

- Add `applyWorkaroundToRiveOnOldAndroidVersions`. Experimental workaround when loading native libraries on Android 6 (see [this issue](https://github.com/rive-app/rive-flutter/issues/403)). The method should be called before using any Rive APIs.

## 0.4.9

- Flutter Wasm compatibility
- Add missing privacy key NSPrivacyCollectedDataTypes for iOS & macOS

## 0.4.8

- Add Privacy manifest for iOS & macOS runtimes

## 0.4.5

- Bump WASM stack size for MP3 decoding.

## 0.4.4

- More build fixes for Windows.

## 0.4.3

- Build fixes for Windows.

## 0.4.2

- More aggressive audio cleanup while playing many sounds concurrently.

## 0.4.1

- Memory leak fixes for audio.

## 0.4.0

- Audio support for volume and level monitoring.

## 0.3.3

- Fixed size issue in FFI where Rive assumed sizes were 64 bit. Details (here)[https://github.com/rive-app/rive-flutter/issues/347#issuecomment-1979496123]

## 0.3.2

- Remove Taffy dependency

## 0.3.0

- Audio Engine for Rive in FFI and WASM.

## 0.2.9

- Taffy updates - flex & grid support in FFI, flex in WASM.

## 0.2.8

- Increase HTTP dependency range for Rive and Rive Common
- Taffy dependency for layouts via FFI and WASM.

# 0.2.7

- Fix for updated Windows clang.

# 0.2.6

- Support for line spacing.

# 0.2.5

- Only fixRequireJs if it is defined.

# 0.2.4

- Fixed a memory leak.

# 0.2.3

- Support for xpos from glyph line.

# 0.2.2

- Fix missing build dependencies

# 0.2.1

- Update `http` package to v1.1.0

# 0.2.0

- Adds line height and text features (ex. ligatures)

# 0.1.0

- Changes text engine font variation configuration calls to support features.

# 0.0.10

- Adds Android namespace to support Gradle 8 (issue [312](https://github.com/rive-app/rive-flutter/issues/312))
-

# 0.0.9

- Fixes setUrlStrategy called from rive_common and fixes a wasm issue.

# 0.0.8

- Text improvements in prep of text features for Rive.

# 0.0.7

- Changes for joystick support.

# 0.0.4

- Add Glyph offsets to fix Arabic Diacritics.

# 0.0.3

- Helpers for x and y direction getters from Mat2D.
- Normalize a Vec2D in place with .norm()
- Multiplication operator for Vec2D.

## 0.0.2

- Support for variable fonts.

## 0.0.1

- First release!
- New common library shared by Rive runtime and editor.
