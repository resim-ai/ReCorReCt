# Re-Capitalizer Chrome Extension

A Chrome extension that automatically transforms text on web pages by capitalizing "re" to "Re" and the letter immediately following it.

## What it does

This extension scans all text content on web pages and transforms words containing "re" followed by another letter:

- `research` → `ReSearch`
- `return` → `ReTurn`
- `really` → `ReAlly`
- `result` → `ReSult`
- `develop` → `develop` (no change - doesn't contain "re" pattern)

## Installation

### Option 1: Load as Unpacked Extension (Developer Mode)

1. **Download/Clone** the extension files to your computer
2. **Open Chrome** and navigate to `chrome://extensions/`
3. **Enable Developer Mode** by clicking the toggle in the top right corner
4. **Click "Load unpacked"** button
5. **Select the folder** containing the extension files (`manifest.json`, `content.js`, `README.md`)
6. The extension will be installed and active immediately

### Option 2: Package and Install

1. In Chrome, go to `chrome://extensions/`
2. Enable Developer Mode
3. Click "Pack extension"
4. Select the extension folder
5. This creates a `.crx` file that can be distributed

## How it works

The extension uses a content script that:

1. **Scans all text** on the webpage when it loads
2. **Uses regex pattern** `/\bre([a-zA-Z])/g` to find "re" followed by any letter at word boundaries
3. **Transforms matches** to "Re" + capitalized following letter
4. **Monitors dynamic content** using MutationObserver to handle single-page applications and dynamically loaded content
5. **Preserves page functionality** by avoiding script tags, style elements, and other non-text content

## Technical Details

- **Manifest Version**: 3 (latest Chrome extension standard)
- **Permissions**: `activeTab` (minimal permissions required)
- **Runs on**: All URLs (`<all_urls>`)
- **Execution**: Document end (after DOM is loaded)
- **Performance**: Efficiently processes only text nodes, skips scripts/styles

## Files Structure

```
chrome-extension/
├── manifest.json    # Extension configuration
├── content.js      # Main text transformation logic
└── README.md       # This documentation
```

## Privacy

This extension:

- ✅ **Runs locally** - all text processing happens in your browser
- ✅ **No data collection** - doesn't send any information anywhere
- ✅ **No network requests** - works entirely offline
- ✅ **Minimal permissions** - only requires access to the active tab

## Browser Compatibility

- **Chrome** ✅ (Primary target)
- **Edge** ✅ (Chromium-based)
- **Brave** ✅ (Chromium-based)
- **Firefox** ❌ (Would need manifest v2 adaptation)

## Troubleshooting

**Extension not working?**

1. Check that it's enabled in `chrome://extensions/`
2. Try refreshing the webpage
3. Check browser console for any errors

**Performance issues?**

- The extension is optimized to minimize performance impact
- If you experience slowdowns on large pages, you can temporarily disable it

**Text not transforming correctly?**

- The extension only affects text content, not images or other media
- Some websites may override text changes - this is expected behavior

## Development

To modify the extension:

1. Edit the `content.js` file to change transformation logic
2. Update `manifest.json` if changing permissions or configuration
3. Go to `chrome://extensions/` and click the refresh button on the extension
4. Test on various websites to ensure compatibility

## License

Free to use and modify for personal and educational purposes.
