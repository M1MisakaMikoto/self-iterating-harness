import { readFileSync } from 'node:fs';
import { JSDOM } from 'jsdom';

const file = process.argv[2];
if (!file) {
  console.error('usage: node validate-mermaid.mjs <blocks.json>');
  process.exit(2);
}

const dom = new JSDOM('<!DOCTYPE html><html><body></body></html>', {
  url: 'http://localhost/',
});
const { window } = dom;
globalThis.window = window;
globalThis.document = window.document;
Object.defineProperty(globalThis, 'navigator', {
  value: window.navigator,
  configurable: true,
});
globalThis.DOMParser = window.DOMParser;
globalThis.Node = window.Node;
globalThis.Element = window.Element;
globalThis.HTMLElement = window.HTMLElement;
globalThis.SVGElement = window.SVGElement;
globalThis.getComputedStyle = window.getComputedStyle;
globalThis.MutationObserver = window.MutationObserver;
globalThis.NodeFilter = window.NodeFilter;
globalThis.DocumentFragment = window.DocumentFragment;

const mermaid = (await import('mermaid')).default;
mermaid.initialize({ startOnLoad: false, securityLevel: 'loose' });

const text = readFileSync(file, 'utf8').replace(/^\uFEFF/, '');
const blocks = JSON.parse(text);
let failed = 0;
for (const block of blocks) {
  try {
    await mermaid.parse(block.code, { suppressErrors: false });
  } catch (err) {
    failed += 1;
    const msg = err?.str || err?.message || String(err);
    console.error(
      `[mermaid] block #${block.index} (starts at md line ${block.line}): ${msg}`
    );
  }
}

if (failed > 0) {
  console.error(`[mermaid] ${failed}/${blocks.length} block(s) failed syntax check`);
  process.exit(1);
}
console.log(`[mermaid] ${blocks.length} block(s) OK`);
