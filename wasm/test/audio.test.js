const fs = require("fs");
const initRiveCommon = require("../build/bin/debug/rive_text.js");

test("audio engine creation", async () => {
  const riveCommon = await initRiveCommon();
  // Can't actually use web audio in Jest :( gotta mock it.
  expect(riveCommon.makeAudioEngine).not.toBe(undefined);
});

test("audio buffer creation", async () => {
  const riveCommon = await initRiveCommon();
  expect(riveCommon.makeAudioSourceBuffer).not.toBe(undefined);
  var buffer = riveCommon.makeAudioSourceBuffer(1024);
  expect(riveCommon.simpleArrayData(buffer)).not.toBe(0);
  expect(riveCommon.simpleArraySize(buffer)).toBe(1024);
});

test("fake play", async () => {
  const riveCommon = await initRiveCommon();

  riveCommon.playAudioSource(0, 0, 0, 0, 0);
});
