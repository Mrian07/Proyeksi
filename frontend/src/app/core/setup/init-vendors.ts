

// 'Global' dependencies
//
// dependencies required by classic (Rails) and Angular application.

// Lodash
require('expose-loader?_!lodash');

// jQuery
require('expose-loader?jQuery!jquery');
require('jquery-ujs');

require('expose-loader?mousetrap!mousetrap/mousetrap.js');

// Angular dependencies
require('expose-loader?dragula!dragula/dist/dragula.min.js');
require('@uirouter/angular');

// Jquery UI
require('jquery-ui/ui/core.js');
require('jquery-ui/ui/position.js');
require('jquery-ui/ui/disable-selection.js');
require('jquery-ui/ui/widgets/sortable.js');
require('jquery-ui/ui/widgets/autocomplete.js');
require('jquery-ui/ui/widgets/dialog.js');
require('jquery-ui/ui/widgets/tooltip.js');

require('expose-loader?moment!moment');
require('moment/locale/en-gb.js');
require('moment/locale/de.js');

require('jquery.caret');
// Text highlight for autocompleter
require('mark.js/dist/jquery.mark.min.js');
// Micro Text fuzzy search library
require('fuse.js');

require('moment-timezone/builds/moment-timezone-with-data.min.js');

require('expose-loader?URI!urijs');
require('urijs/src/URITemplate');

require('expose-loader?I18n!core-vendor/i18n');

// Localization for fullcalendar
require('@fullcalendar/core/locales-all');
