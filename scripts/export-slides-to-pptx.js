#!/usr/bin/env node
/**
 * Export HTML slides to PowerPoint
 *
 * Captures screenshots of each .slide element from a slides page and
 * assembles them into a PowerPoint presentation.
 *
 * Prerequisites:
 *   - Jekyll dev server running: ./build/website/serve.sh
 *   - Node dependencies installed: yarn install
 *
 * Usage:
 *   node scripts/export-slides-to-pptx.js <slug> [output-filename]
 *
 * Arguments:
 *   slug            - The slide deck slug (e.g., "2026-01-salon-elevated-cuisine")
 *   output-filename - Optional. Defaults to "<slug>.pptx"
 *
 * Examples:
 *   node scripts/export-slides-to-pptx.js 2026-01-salon-elevated-cuisine
 *   node scripts/export-slides-to-pptx.js 2026-01-salon-restaurants my-presentation.pptx
 */

const puppeteer = require('puppeteer');
const PptxGenJS = require('pptxgenjs');
const fs = require('fs');
const path = require('path');

const BASE_URL = 'http://localhost:4000';
const SLIDES_PATH = '/slides';

async function checkServerRunning(url) {
  try {
    const response = await fetch(url);
    return response.ok;
  } catch {
    return false;
  }
}

async function exportSlidesToPptx(slug, outputFilename) {
  const url = `${BASE_URL}${SLIDES_PATH}/${slug}/`;
  const outputPath = outputFilename || `${slug}.pptx`;

  console.log(`Exporting slides from: ${url}`);
  console.log(`Output file: ${outputPath}`);
  console.log('');

  // Check if server is running
  const serverRunning = await checkServerRunning(BASE_URL);
  if (!serverRunning) {
    console.error('Error: Jekyll dev server is not running.');
    console.error('Start it with: ./build/website/serve.sh');
    process.exit(1);
  }

  // Check if the slides page exists
  const pageExists = await checkServerRunning(url);
  if (!pageExists) {
    console.error(`Error: Slides page not found at ${url}`);
    console.error('');
    console.error('Available slides can be found at: http://localhost:4000/slides/');
    process.exit(1);
  }

  // Launch browser
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  try {
    const page = await browser.newPage();

    // Set viewport to slide dimensions
    await page.setViewport({
      width: 1920,
      height: 1080,
      deviceScaleFactor: 2 // Higher quality screenshots
    });

    // Navigate to the slides page
    await page.goto(url, { waitUntil: 'networkidle0' });

    // Wait for slides to load
    await page.waitForSelector('.slide', { timeout: 10000 });

    // Get all slide elements
    const slideCount = await page.evaluate(() => {
      return document.querySelectorAll('.slide').length;
    });

    if (slideCount === 0) {
      throw new Error('No slides found on page');
    }

    console.log(`Found ${slideCount} slides`);

    // Create temp directory for screenshots
    const tempDir = path.join(__dirname, '../_temp_slides');
    if (!fs.existsSync(tempDir)) {
      fs.mkdirSync(tempDir, { recursive: true });
    }

    // Screenshot each slide
    const slideImages = [];
    for (let i = 0; i < slideCount; i++) {
      process.stdout.write(`Capturing slide ${i + 1}/${slideCount}...\r`);

      // Get the bounding box of the slide
      const slideBox = await page.evaluate((index) => {
        const slide = document.querySelectorAll('.slide')[index];
        const rect = slide.getBoundingClientRect();
        return {
          x: rect.x,
          y: rect.y,
          width: rect.width,
          height: rect.height
        };
      }, i);

      // Screenshot the slide
      const screenshotPath = path.join(tempDir, `slide-${i + 1}.png`);
      await page.screenshot({
        path: screenshotPath,
        clip: {
          x: slideBox.x,
          y: slideBox.y,
          width: 1920,
          height: 1080
        }
      });

      slideImages.push(screenshotPath);
    }

    console.log(`Captured ${slideCount} slides.        `);

    // Create PowerPoint
    console.log('Creating PowerPoint...');
    const pptx = new PptxGenJS();

    // Set presentation properties (16:9 aspect ratio)
    pptx.defineLayout({ name: 'CUSTOM_16_9', width: 10, height: 5.625 });
    pptx.layout = 'CUSTOM_16_9';
    pptx.title = slug;

    // Add each slide image
    for (let i = 0; i < slideImages.length; i++) {
      const slide = pptx.addSlide();
      slide.addImage({
        path: slideImages[i],
        x: 0,
        y: 0,
        w: '100%',
        h: '100%'
      });
    }

    // Save the presentation
    await pptx.writeFile({ fileName: outputPath });
    console.log(`PowerPoint saved: ${outputPath}`);

    // Clean up temp files
    for (const img of slideImages) {
      fs.unlinkSync(img);
    }
    fs.rmdirSync(tempDir);

    console.log('Done!');
  } finally {
    await browser.close();
  }
}

// Parse command line arguments
const args = process.argv.slice(2);
if (args.length < 1) {
  console.log('Export HTML slides to PowerPoint');
  console.log('');
  console.log('Usage: node scripts/export-slides-to-pptx.js <slug> [output-filename]');
  console.log('');
  console.log('Arguments:');
  console.log('  slug            - The slide deck slug (e.g., "2026-01-salon-elevated-cuisine")');
  console.log('  output-filename - Optional. Defaults to "<slug>.pptx"');
  console.log('');
  console.log('Examples:');
  console.log('  node scripts/export-slides-to-pptx.js 2026-01-salon-elevated-cuisine');
  console.log('  node scripts/export-slides-to-pptx.js 2026-01-salon-restaurants my-presentation.pptx');
  console.log('');
  console.log('Prerequisites:');
  console.log('  - Jekyll dev server running: ./build/website/serve.sh');
  console.log('  - Node dependencies installed: yarn install');
  process.exit(1);
}

const [slug, outputFilename] = args;
exportSlidesToPptx(slug, outputFilename).catch(err => {
  console.error('Error:', err.message);
  process.exit(1);
});
