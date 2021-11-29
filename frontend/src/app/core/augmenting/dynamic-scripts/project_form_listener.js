
(function($) {
  $(function() {
    function observeTemplateChanges() {
      jQuery('#project-select-template').on('change', function() {
        const name = document.getElementById('project_name');
        const fieldset = document.getElementById('advanced-project-settings');

        // When the advanced settings were opened once, we assume they were changed
        // and show an alert before switching the template
        if (!fieldset.dataset.touched || window.confirm(I18n.t('js.project.confirm_template_load'))) {
          let params = new URLSearchParams(location.search);
          params.set('template_project', this.value);
          params.set('name', name.value);
          window.location.search = params.toString();
        }
      });
    }

    function focusOnName() {
      const name = document.getElementById('project_name');
      if (!name.value) {
        name.focus();
      }
    }

    function expandAdvancedOnParams() {
      const fieldset = document.getElementById('advanced-project-settings');
      let params = new URLSearchParams(location.search);

      if (params.has('parent_id')) {
        fieldset.querySelector('.form--fieldset-legend').click();
      }
    }

    observeTemplateChanges();
    expandAdvancedOnParams();
    focusOnName();
  });
}(jQuery));
