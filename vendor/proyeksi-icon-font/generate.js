#!/usr/bin/env node

const webfontsGenerator = require('webfonts-generator');
const path = require('path');
const fs = require('fs');
const glob = require("glob")

webfontsGenerator({
  files: glob.sync("src/*.svg"),
  "fontName": "proyeksi-icon-font",
  "cssFontsUrl": "../../frontend/src/assets/fonts/proyeksi_icon/",
  "dest": path.resolve(__dirname, '..', '..', 'frontend', 'src', 'assets', 'fonts', 'proyeksi_icon'),
  "cssDest": path.join(path.resolve(__dirname, '..', '..', 'frontend', 'src', 'global_styles', 'fonts'), '_proyeksi_icon_definitions.scss'),
  "cssTemplate": "proyeksi-icon-font.template.scss",
  "classPrefix": "icon-",
  "baseSelector": ".icon",
  "html": true,
  "htmlDest": path.join(path.resolve(__dirname, '..', '..', 'frontend', 'src', 'global_styles', 'fonts'), '_proyeksi_icon_font.lsg'),
  "htmlTemplate": "proyeksi-icon-font.template.lsg",
  "types": ['woff2', 'woff'],
  "fixedWidth": true,
  "descent": 100
}, function(error) {
  if (error) {
    console.log('Failed to build icon font. ', error);
  }
});
