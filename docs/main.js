main();

function main() {
  const skippedNodes = new Set(["h2", "h3", "pre"]);
  const textNodes = textNodesUnder();
  for (const node of textNodes) {
    if (skippedNodes.has(node.parentNode.localName)) {
      continue;
    }
    processNode(node);
  }
}

function textNodesUnder() {
  const el = document.querySelector(".container")
  const a = [];
  let n;
  const walk = document.createTreeWalker(el, NodeFilter.SHOW_TEXT, null, false);
  while ((n = walk.nextNode())) {
    a.push(n);
  }
  return a;
}

function processNode(node) {
  const fragment = document.createDocumentFragment();
  node.textContent.split(/\s+/).forEach((word) => {
    const span = document.createElement("span");
    span.textContent = word;
    fragment.appendChild(span);
    fragment.appendChild(document.createTextNode(" "));

    const trimmedWord = word.replace(/['",.:]/g, '');

    const lword = trimmedWord.toLowerCase();
    const stem = word2stem[lword];
    if (!stem) {
      return;
    }
    const meaning = dic[stem];
    if (!meaning) {
      return;
    }

    span.className = "word";
    const label = document.createElement("div");
    label.textContent = meaning;
    label.className = "word-label";
    span.appendChild(label);
  });
  if (fragment.children.length > 0 && fragment.lastChild.textContent === " ") {
    fragment.removeChild(fragment.lastChild);
  }
  node.parentNode.replaceChild(fragment, node);
}
