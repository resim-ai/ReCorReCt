// Re-Capitalizer Chrome Extension Content Script
// Transforms "re" + letter patterns to "Re" + capitalized letter

(function () {
  "use strict";

  // Regex to match "re" followed by any letter at word boundaries
  const RE_PATTERN = /\bre([a-zA-Z])/g;

  // Function to transform text using the re-capitalization rule
  function transformText(text) {
    return text.replace(RE_PATTERN, function (match, followingLetter) {
      return "Re" + followingLetter.toUpperCase();
    });
  }

  // Function to process all text nodes in a given element
  function processTextNodes(element) {
    // Get all text nodes using a TreeWalker
    const walker = document.createTreeWalker(
      element,
      NodeFilter.SHOW_TEXT,
      {
        acceptNode: function (node) {
          // Skip script and style elements
          const parent = node.parentElement;
          if (!parent) return NodeFilter.FILTER_REJECT;

          const tagName = parent.tagName.toLowerCase();
          if (tagName === "script" || tagName === "style" || tagName === "noscript") {
            return NodeFilter.FILTER_REJECT;
          }

          // Skip if the text node is empty or only whitespace
          if (!node.textContent.trim()) {
            return NodeFilter.FILTER_REJECT;
          }

          return NodeFilter.FILTER_ACCEPT;
        }
      },
      false
    );

    const textNodes = [];
    let node;

    // Collect all text nodes first to avoid DOM modification during traversal
    while ((node = walker.nextNode())) {
      textNodes.push(node);
    }

    // Process each text node
    textNodes.forEach((textNode) => {
      const originalText = textNode.textContent;
      const transformedText = transformText(originalText);

      // Only update if the text actually changed
      if (originalText !== transformedText) {
        textNode.textContent = transformedText;
      }
    });
  }

  // Function to initialize the transformation on page load
  function initializeTransformation() {
    // Process existing content
    processTextNodes(document.body);

    // Set up MutationObserver to handle dynamically added content
    const observer = new MutationObserver(function (mutations) {
      mutations.forEach(function (mutation) {
        // Process added nodes
        mutation.addedNodes.forEach(function (node) {
          // Only process element nodes and text nodes
          if (node.nodeType === Node.ELEMENT_NODE) {
            processTextNodes(node);
          } else if (node.nodeType === Node.TEXT_NODE) {
            const parent = node.parentElement;
            if (parent) {
              const tagName = parent.tagName.toLowerCase();
              // Skip script and style elements
              if (tagName !== "script" && tagName !== "style" && tagName !== "noscript") {
                const originalText = node.textContent;
                const transformedText = transformText(originalText);
                if (originalText !== transformedText) {
                  node.textContent = transformedText;
                }
              }
            }
          }
        });
      });
    });

    // Start observing changes to the DOM
    observer.observe(document.body, {
      childList: true,
      subtree: true,
      characterData: true
    });

    console.log("Re-Capitalizer extension initialized");
  }

  // Initialize when DOM is ready
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initializeTransformation);
  } else {
    // DOM is already loaded
    initializeTransformation();
  }

  // Also run on window load as a fallback
  window.addEventListener("load", function () {
    // Re-process in case anything was missed
    processTextNodes(document.body);
  });
})();
