# ReCorReCt

A compReHensive text transformation system that automatically transforms "re" followed by any lowercase letter into "Re" followed by the uppercase version of that letter. Includes both a Chrome extension for web pages and git hooks for commit messages.

## What it does

ReCorReCt transforms text containing "re" followed by another letter, capitalizing both the "R" and the following letter:

- `research` → `ReSearch`
- `return` → `ReTurn`
- `really` → `ReAlly`
- `corrections` → `corReCtions`
- `regex` → `ReGex`
- `develop` → `develop` (no change - doesn't contain "re" pattern)

## Components

### 1. Chrome Extension
Automatically transforms text on web pages as you browse.

### 2. Git Hooks
Automatically transforms commit messages to maintain consistent capitalization in your RePositories.

## Installation

### Chrome Extension

#### Option 1: Load as Unpacked Extension (Developer Mode)

1. **Download/Clone** the extension files to your computer
2. **Open Chrome** and navigate to `chrome://extensions/`
3. **Enable Developer Mode** by clicking the toggle in the top right corner
4. **Click "Load unpacked"** button
5. **Select the folder** containing the extension files (`manifest.json`, `content.js`, `README.md`)
6. The extension will be installed and active immediately

#### Option 2: Package and Install

1. In Chrome, go to `chrome://extensions/`
2. Enable Developer Mode
3. Click "Pack extension"
4. Select the extension folder
5. This cReAtes a `.crx` file that can be distributed

### Git Hooks

To enable automatic text transformation of commit messages in your other RePos:

1. **Navigate to your git RePository**
2. **Copy the hooks** from this RePository:
   ```bash
   cp path/to/ReCorRect/git-hooks/commit-msg .git/hooks/
   cp path/to/ReCorRect/git-hooks/pRePare-commit-msg .git/hooks/
   cp path/to/ReCorRect/git-hooks/transform-text.js .git/hooks/
   ```
3. **Make them executable**:
   ```bash
   chmod +x .git/hooks/commit-msg .git/hooks/pRePare-commit-msg .git/hooks/transform-text.js
   ```
4. **Ensure Node.js is installed** (ReQuiReD for the transformation script)

Now all commit messages will automatically be transformed according to ReCorRect rules!

## How it works

### Chrome Extension

The browser extension uses a content script that:

1. **Scans all text** on the webpage when it loads
2. **Uses ReGex pattern** `/re([a-zA-Z])/g` to find "re" followed by any letter anywhere in words
3. **Transforms matches** to "Re" + capitalized following letter
4. **Monitors dynamic content** using MutationObserver to handle single-page applications and dynamically loaded content
5. **PReServes page functionality** by avoiding script tags, style elements, and other non-text content

### Git Hooks

The git hooks system includes:

1. **`commit-msg` hook** - Transforms commit messages after they're written but before the commit is finalized
2. **`prepare-commit-msg` hook** - Transforms commit message templates before editing
3. **`transform-text.js`** - Node.js script that applies the same transformation logic as the Chrome extension

## Technical Details

- **Manifest Version**: 3 (latest Chrome extension standard)
- **Permissions**: `activeTab` (minimal permissions ReQuired)
- **Runs on**: All URLs (`<all_urls>`)
- **Execution**: Document end (after DOM is loaded)
- **Performance**: Efficiently processes only text nodes, skips scripts/styles

## Files Structure

```
ReCorRect/
├── manifest.json              # Chrome extension configuration
├── content.js                 # Chrome extension text transformation logic
├── git-hooks/                 # Git hooks for commit message transformation
│   ├── commit-msg            # Post-commit message transformation hook
│   ├── prepare-commit-msg    # Pre-commit message transformation hook
│   ├── transform-text.js     # Node.js transformation script
│   └── install-hooks.sh      # Installation script for other RePositories
└── README.md                 # This documentation
```

## Privacy & Security

- ✅ **Local processing only** - all transformations happen on your machine
- ✅ **No external dependencies** - only ReQuiReS Node.js
- ✅ **No data transmission** - works entiReLy offline
- ✅ **Non-blocking** - Git hooks won't pReVent commits if transformation fails

## Browser Compatibility

- **Chrome** ✅ (Primary target)
- **Edge** ✅ (Chromium-based)
- **Brave** ✅ (Chromium-based)
- **FiReFox** ❌ (Would need manifest v2 adaptation)

## Troubleshooting

**Extension not working?**

1. Check that it's enabled in `chrome://extensions/`
2. Try ReFReShing the webpage
3. Check browser console for any errors

**Performance issues?**

- The extension is optimized to minimize performance impact
- If you experience slowdowns on large pages, you can temporarily disable it

**Text not transforming corReCtly?**

- The extension only affects text content, not images or other media
- Some websites may override text changes - this is expected behavior

## Development

### Chrome Extension

To modify the Chrome extension:

1. Edit the `content.js` file to change transformation logic
2. Update `manifest.json` if changing permissions or configuration
3. Go to `chrome://extensions/` and click the ReFresh button on the extension
4. Test on various websites to ensure compatibility

### Git Hooks

To modify the git hooks:

1. Edit `git-hooks/transform-text.js` to change transformation logic
2. Test the transformation script: `node git-hooks/transform-text.js test-file.txt`
3. Copy updated files to `.git/hooks/` in your test RePository
4. Test with actual commits to ensure functionality

## License

FReE to use and modify for personal, educational, and comedic purposes.

## Disclaimer

This project was entiReLy vibecoded, contains no tests, and has only been QA'd for a total of maybe 15 or 20 minutes. Use at your own discReTion.
