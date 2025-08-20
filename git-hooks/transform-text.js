#!/usr/bin/env node

/**
 * Text Transformation Script for Git Hooks
 * Applies the same "re" capitalization rules as the ReCorReCt Chrome extension
 *
 * Usage: node transform-text.js <input-file> [output-file]
 * If output-file is not provided, modifies input-file in place
 */

const fs = require('fs');
const path = require('path');

// Enhanced regex pattern to match "re" anywhere in words, not just at boundaries
const RE_PATTERN = /re([a-zA-Z])/g;

/**
 * Transform text using the re-capitalization rule
 * @param {string} text - Input text to transform
 * @returns {string} - Transformed text
 */
function transformText(text) {
  return text.replace(RE_PATTERN, function (match, followingLetter) {
    return "Re" + followingLetter.toUpperCase();
  });
}

/**
 * Process a file and apply text transformations
 * @param {string} inputPath - Path to input file
 * @param {string} outputPath - Path to output file (optional)
 */
function processFile(inputPath, outputPath = null) {
  try {
    // Read the input file
    const originalContent = fs.readFileSync(inputPath, 'utf8');

    // Apply transformations
    const transformedContent = transformText(originalContent);

    // Determine output path
    const finalOutputPath = outputPath || inputPath;

    // Write the transformed content
    fs.writeFileSync(finalOutputPath, transformedContent, 'utf8');

    // Log changes if any were made
    if (originalContent !== transformedContent) {
      console.log(`✓ Applied ReCorReCt transformations to: ${path.basename(finalOutputPath)}`);

      // Show the differences for debugging (optional)
      if (process.env.DEBUG_RECORRECT) {
        const lines = originalContent.split('\n');
        const transformedLines = transformedContent.split('\n');

        lines.forEach((line, index) => {
          if (line !== transformedLines[index]) {
            console.log(`  Line ${index + 1}: "${line}" → "${transformedLines[index]}"`);
          }
        });
      }
    }

    return transformedContent;
  } catch (error) {
    console.error(`Error processing file ${inputPath}:`, error.message);
    process.exit(1);
  }
}

// Main execution
function main() {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.error('Usage: node transform-text.js <input-file> [output-file]');
    process.exit(1);
  }

  const inputFile = args[0];
  const outputFile = args[1] || null;

  // Check if input file exists
  if (!fs.existsSync(inputFile)) {
    console.error(`Error: Input file "${inputFile}" does not exist`);
    process.exit(1);
  }

  // Process the file
  processFile(inputFile, outputFile);
}

// Export for testing or module usage
module.exports = {
  transformText,
  processFile
};

// Run main if this script is executed directly
if (require.main === module) {
  main();
}
