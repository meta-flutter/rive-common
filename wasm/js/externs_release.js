// Fixes an issue with emscripten's 3.1.51 compiled JS library attempting to
// reference assert when assertions are disabled.
function assert() {}
