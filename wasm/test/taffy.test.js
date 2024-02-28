const fs = require("fs");
const initRiveText = require("../build/bin/debug/rive_text.js");

test("can init taffy", async () => {
  const riveText = await initRiveText();
  const taffy = riveText.taffyNew();
  expect(taffy).not.toBe(null);
  riveText.taffyRelease(taffy);
});

test("taffy style defaults are as expected", async () => {
  const rive = await initRiveText();

  const style = rive.taffyStyleDefault();
  expect(style.display).toBe(0);
  expect(style.overflow.x).toBe(0);
  expect(style.overflow.y).toBe(0);
  expect(style.scrollbarWidth).toBe(0);
  expect(style.position).toBe(0);
  expect(style.inset.left.tag).toBe(2);
  expect(style.inset.left.value).toBeCloseTo(0);
  expect(style.inset.right.tag).toBe(2);
  expect(style.inset.right.value).toBeCloseTo(0);
  expect(style.inset.top.tag).toBe(2);
  expect(style.inset.top.value).toBeCloseTo(0);
  expect(style.inset.bottom.tag).toBe(2);
  expect(style.inset.bottom.value).toBeCloseTo(0);
  expect(style.size.width.tag).toBe(2);
  expect(style.size.width.value).toBeCloseTo(0);
  expect(style.size.height.tag).toBe(2);
  expect(style.size.height.value).toBeCloseTo(0);
  expect(style.minSize.width.tag).toBe(2);
  expect(style.minSize.width.value).toBeCloseTo(0);
  expect(style.minSize.height.tag).toBe(2);
  expect(style.minSize.height.value).toBeCloseTo(0);
  expect(style.maxSize.width.tag).toBe(2);
  expect(style.maxSize.width.value).toBeCloseTo(0);
  expect(style.maxSize.height.tag).toBe(2);
  expect(style.maxSize.height.value).toBeCloseTo(0);
  expect(style.aspectRatio.tag).toBe(1);
  expect(style.aspectRatio.value).toBeCloseTo(0);

  expect(style.margin.left.tag).toBe(0);
  expect(style.margin.left.value).toBeCloseTo(0);
  expect(style.margin.right.tag).toBe(0);
  expect(style.margin.right.value).toBeCloseTo(0);
  expect(style.margin.top.tag).toBe(0);
  expect(style.margin.top.value).toBeCloseTo(0);
  expect(style.margin.bottom.tag).toBe(0);
  expect(style.margin.bottom.value).toBeCloseTo(0);

  expect(style.padding.left.tag).toBe(0);
  expect(style.padding.left.value).toBe(0);
  expect(style.padding.right.tag).toBe(0);
  expect(style.padding.right.value).toBe(0);
  expect(style.padding.top.tag).toBe(0);
  expect(style.padding.top.value).toBe(0);
  expect(style.padding.bottom.tag).toBe(0);
  expect(style.padding.bottom.value).toBe(0);

  expect(style.border.left.tag).toBe(0);
  expect(style.border.left.value).toBe(0);
  expect(style.border.right.tag).toBe(0);
  expect(style.border.right.value).toBe(0);
  expect(style.border.top.tag).toBe(0);
  expect(style.border.top.value).toBe(0);
  expect(style.border.bottom.tag).toBe(0);
  expect(style.border.bottom.value).toBe(0);

  expect(style.alignItems).toBe(0);
  expect(style.alignSelf).toBe(0);

  expect(style.justifyItems).toBe(0);
  expect(style.justifySelf).toBe(0);

  expect(style.alignContent).toBe(0);

  expect(style.justifyContent).toBe(0);

  expect(style.gap.width.tag).toBe(0);
  expect(style.gap.width.value).toBe(0);
  expect(style.gap.height.tag).toBe(0);
  expect(style.gap.height.value).toBe(0);

  expect(style.flexDirection).toBe(0);

  expect(style.flexWrap).toBe(0);

  expect(style.flexBasis.tag).toBe(2);
  expect(style.flexBasis.value).toBeCloseTo(0);

  expect(style.flexGrow).toBe(0);
  expect(style.flexShrink).toBe(1);
});

test("taffy can create and remove nodes", async () => {
  const rive = await initRiveText();
  const taffy = rive.taffyNew();
  const style = rive.taffyStyleDefault();

  var leafResult = rive.taffyNewLeaf(taffy, style);
  expect(leafResult.tag).toBe(0);
  expect(leafResult.node).not.toBeNull();

  var styleResult = rive.taffySetStyle(taffy, leafResult.node.pointer, style);
  expect(styleResult.tag).toBe(0);

  var removeResult = rive.taffyRemove(taffy, leafResult.node.pointer);
  expect(removeResult.tag).toBe(0);
  expect(removeResult.node.pointer).toBe(leafResult.node.pointer);
});

test("taffy can mark nodes dirty", async () => {
  const rive = await initRiveText();
  const taffy = rive.taffyNew();
  const style = rive.taffyStyleDefault();

  var leafResult = rive.taffyNewLeaf(taffy, style);
  expect(leafResult.tag).toBe(0);
  expect(leafResult.node).not.toBeNull();

  var markDirtyResult = rive.taffyMarkDirty(taffy, leafResult.node.pointer);
  expect(markDirtyResult.tag).toBe(0);
});

test("can call computeLayout", async () => {
  const rive = await initRiveText();
  const taffy = rive.taffyNew();
  const style = rive.taffyStyleDefault();

  style.size.width.tag = 0;
  style.size.width.value = 800;
  style.size.height.tag = 0;
  style.size.height.value = 100;

  var leafResult = rive.taffyNewLeaf(taffy, style);
  expect(leafResult.tag).toBe(0);
  expect(leafResult.node).not.toBeNull();

  var computeLayoutResult = rive.taffyComputeLayout(
    taffy,
    leafResult.node.pointer
  );
  expect(computeLayoutResult.tag).toBe(0);

  var layoutResult = rive.taffyLayout(taffy, leafResult.node.pointer);
  expect(layoutResult.tag).toBe(0);
  expect(layoutResult.layout.order).toBe(0);
  expect(layoutResult.layout.location.x).toBe(0);
  expect(layoutResult.layout.location.y).toBe(0);
  expect(layoutResult.layout.size.width).toBe(800);
  expect(layoutResult.layout.size.height).toBe(100);
});
