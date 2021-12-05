#!/usr/bin/env node

const webfontsGenerator = require('webfonts-generator');
const path = require('path');
const fs = require('fs');
const glob = require("glob")

webfontsGenerator({
  files: glob.sync("src/*.svg"),
  "fontName": "proyeksiapp-icon-font",
  "cssFontsUrl": "../../frontend/src/assets/fonts/proyeksiapp_icon/",
  "dest": path.resolve(__dirname, '..', '..', 'frontend', 'src', 'assets', 'fonts', 'proyeksiapp_icon'),
  "cssDest": path.join(path.resolve(__dirname, '..', '..', 'frontend', 'src', 'global_styles', 'fonts'), '_proyeksiapp_icon_definitions.scss'),
  "cssTemplate": "proyeksiapp-icon-font.template.scss",
  "classPrefix": "icon-",
  "baseSelector": ".icon",
  "html": true,
  "htmlDest": path.join(path.resolve(__dirname, '..', '..', 'frontend', 'src', 'global_styles', 'fonts'), '_proyeksiapp_icon_font.lsg'),
  "htmlTemplate": "proyeksiapp-icon-font.template.lsg",
  "types": ['woff2', 'woff'],
  "fixedWidth": true,
  "descent": 100
}, function(error) {
  if (error) {
    console.log('Failed to build icon font. ', error);
  }
});
