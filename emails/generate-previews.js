#!/usr/bin/env node

/**
 * Generate browser-previewable versions of email templates
 * by substituting Mailchimp merge tags with preview values.
 *
 * Usage: node generate-previews.js
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const EMAILS_DIR = __dirname;
const PREVIEW_DIR = path.join(EMAILS_DIR, '_previews');
const VALUES_FILE = path.join(EMAILS_DIR, 'preview-values.yml');

// Load preview values
function loadPreviewValues() {
    const content = fs.readFileSync(VALUES_FILE, 'utf8');
    return yaml.load(content);
}

// Substitute Mailchimp merge tags with preview values
function substituteMergeTags(html, values) {
    let result = html;

    // Handle conditional blocks: *|IF:TAG|*content*|ELSE:|*fallback*|END:IF|*
    // For preview, show the IF branch when the tag has a value, otherwise show ELSE branch
    result = result.replace(
        /\*\|IF:(\w+)\|\*([\s\S]*?)\*\|ELSE:\|\*([\s\S]*?)\*\|END:IF\|\*/g,
        (match, tag, ifContent, elseContent) => {
            return values[tag] ? ifContent : elseContent;
        }
    );

    // Handle conditional blocks without ELSE: *|IF:TAG|*content*|END:IF|*
    result = result.replace(
        /\*\|IF:(\w+)\|\*([\s\S]*?)\*\|END:IF\|\*/g,
        (match, tag, content) => {
            return values[tag] ? content : '';
        }
    );

    // Replace standard merge tags: *|TAG|*
    for (const [tag, value] of Object.entries(values)) {
        const pattern = new RegExp(`\\*\\|${tag.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\|\\*`, 'g');
        result = result.replace(pattern, value);
    }

    return result;
}

// Get all HTML email files (excluding previews)
function getEmailFiles() {
    return fs.readdirSync(EMAILS_DIR)
        .filter(file => file.endsWith('.html') && !file.startsWith('_'));
}

// Main
function main() {
    // Create preview directory if it doesn't exist
    if (!fs.existsSync(PREVIEW_DIR)) {
        fs.mkdirSync(PREVIEW_DIR, { recursive: true });
    }

    // Load values
    const values = loadPreviewValues();
    console.log('Loaded preview values from preview-values.yml');

    // Process each email file
    const emailFiles = getEmailFiles();

    if (emailFiles.length === 0) {
        console.log('No email templates found.');
        return;
    }

    for (const file of emailFiles) {
        const inputPath = path.join(EMAILS_DIR, file);
        const outputPath = path.join(PREVIEW_DIR, file);

        const html = fs.readFileSync(inputPath, 'utf8');
        const preview = substituteMergeTags(html, values);

        fs.writeFileSync(outputPath, preview);
        console.log(`Generated: _previews/${file}`);
    }

    console.log(`\nOpen previews in your browser:`);
    for (const file of emailFiles) {
        console.log(`  file://${path.join(PREVIEW_DIR, file)}`);
    }
}

main();
