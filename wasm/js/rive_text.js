Module["onRuntimeInitialized"] = function () {
  var nativeMakeGlyphPath = Module["makeGlyphPath"];
  var move = 0;
  var line = 1;
  var quad = 2;
  var cubic = 4;
  var close = 5;
  Module["makeGlyphPath"] = function (font, glyphId) {
    var glyph = nativeMakeGlyphPath(font, glyphId);
    var verbCount = glyph[3];
    var ptsPtr = glyph[1];
    var verbPtr = glyph[2];
    var verbs = Module["heapViewU8"](verbPtr, verbCount);

    let pointCount = 0;
    for (var verb of verbs) {
      switch (verb) {
        case move:
        case line:
          pointCount++;
          break;
        case quad:
          pointCount += 2;
          break;
        case cubic:
          pointCount += 3;
          break;
        default:
          break;
      }
    }

    const ptsStart = ptsPtr >> 2;
    return {
      "rawPath": glyph[0],
      "verbs": verbs,
      "points": Module["heapViewF32"](ptsStart, pointCount * 2),
    };
  };

  var nativeShapeText = Module["shapeText"];
  Module["shapeText"] = function (codeUnits, runsList) {
    var shapeResult = nativeShapeText(codeUnits, runsList);
    return {
      "rawResult": shapeResult,
      "results": Module["heapViewU8"](shapeResult),
    };
  };

  var nativeBreakLines = Module["breakLines"];
  Module["breakLines"] = function (shape, width, align) {
    var breakResult = nativeBreakLines(shape, width, align);
    return {
      "rawResult": breakResult,
      "results": Module["heapViewU8"](breakResult),
    };
  };

  var nativeFontFeatures = Module["fontFeatures"];
  Module["fontFeatures"] = function (font) {
    var featuresPtr = nativeFontFeatures(font);
    var heap = Module["heap"]();
    const view = new DataView(heap, featuresPtr);
    var dataPtr = view["getUint32"](0, true);
    var size = view["getUint32"](4, true);

    const dataView = new DataView(heap, dataPtr);

    var tags = [];
    for (var i = 0; i < size; i++) {
      var tag = dataView["getUint32"](i * 4, true);
      tags.push(tag);
    }

    Module["deleteFontFeatures"](featuresPtr);
    return tags;
  };

  Module["heap"] = function (start, length) {
    var wasmMemory = Module["wasmMemory"];
    if (!wasmMemory) {
      return Module["HEAPU8"]["buffer"];
    }
    return wasmMemory["buffer"];
  };

  Module["heapViewU8"] = function (start, length) {
    var wasmMemory = Module["wasmMemory"];
    if (!wasmMemory) {
      return new Uint8Array(Module["HEAPU8"]["buffer"], start, length);
    }
    return new Uint8Array(wasmMemory["buffer"], start, length);
  };

  Module["heapViewF32"] = function (start, length) {
    var wasmMemory = Module["wasmMemory"];
    if (!wasmMemory) {
      return new Float32Array(Module["HEAPF32"]["buffer"], start << 2, length);
    }
    return new Float32Array(wasmMemory["buffer"], start << 2, length);
  };
};
