

import 'hammerjs';

// Global scripts previously part of the application.js
// Avoid require.context since that crashes angular regularly
import './globals/dynamic-bootstrapper';
import './globals/global-listeners';
import './globals/openproject';
import './globals/tree-menu';
