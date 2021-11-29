

require('./init-angularjs');
require('jquery-mockjax')(jQuery, window);

var requireComponent;

requireComponent = require.context('../tests/unit/tests/', true, /test\.(js|ts)$/);
requireComponent.keys().forEach(requireComponent);

requireComponent = require.context('./components/', true, /^.*\.test\.(js|ts)$/);
requireComponent.keys().forEach(requireComponent);

requireComponent = require.context('./modules/', true, /^.*\.test\.(js|ts)$/);
requireComponent.keys().forEach(requireComponent);


// Disable jQuery animations for the run
jQuery.fx.off = true;
