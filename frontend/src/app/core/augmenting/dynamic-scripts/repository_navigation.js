

(function($) {
  $(function() {
    var revision = $('#revision-identifier-input'),
        form = revision.closest('form'),
        tag = $('#revision-tag-select'),
        branch = $('#revision-branch-select'),
        selects = tag.add(branch),
        branch_selected = branch.length > 0 && revision.val() == branch.val(),
        tag_selected = tag.length > 0 && revision.val() == tag.val();

    var sendForm = function() {
      selects.prop('disable', true);
      form.submit();
      selects.prop('disable', false);
    };

    /*
    If we're viewing a tag or branch, don't display it in the
    revision box
    */
    if (branch_selected || tag_selected) {
      revision.val('');
    }

    /*
    Copy the branch/tag value into the revision box, then disable
    the dropdowns before submitting the form
    */
    selects.on('change', function() {
      var select = $(this);
      revision.val(select.val());
      sendForm();
    });

    /*
    Disable the branch/tag dropdowns before submitting the revision form
    */
    revision.on('keydown', function(e) {
      if (e.keyCode == 13) {
        sendForm();
      }
    });


    // Dir expanders
    var repoBrowser = $('#browser');
    repoBrowser.on('click', '.dir-expander', function() {
      var el = $(this),
          id = $(this).data('element'),
          content = $(id);

          if (expandDir(content)) {
            content.addClass('loading');
            $.ajax({
              url: el.data('url'),
              success: function(response) {
                content.after(response);
                content.removeClass('loading');
                content.addClass('loaded open');
                content.find('a.dir-expander')[0].title = I18n.t('js.label_collapse');
              }
            });
          }
    });

    /**
     * Collapses a directory listing in the repository module
     */
    function collapseScmEntry(content) {
      repoBrowser.find('.' + content.attr('id')).each(function() {
        var el = $(this);
        if (el.hasClass('open')) {
          collapseScmEntry(el);
        }

        el.hide();
        el.toggleClass('open collapsed');
      });

      content.toggleClass('open collapsed')
      content.find('a.dir-expander')[0].title = I18n.t('js.label_expand');
    }

    /**
     * Expands an SCM entry if its loaded
     */
    function expandScmEntry(content) {
      repoBrowser.find('.' + content.attr('id')).each(function() {
        var el = $(this);
        el.show();
        if (el.hasClass('loaded') && !el.hasClass('collapsed')) {
          expandScmEntry(el);
        }

        el.toggleClass('open collapsed')
      });

      content.toggleClass('open collapsed')
      content.find('a.dir-expander')[0].title = I18n.t('js.label_collapse');
    }

    /**
     * Determines whether a dir-expander should load content
     * or simply expand already loaded content.
     */
    function expandDir(content) {
        if (content.hasClass('open')) {
            collapseScmEntry(content);
            return false;
        } else if (content.hasClass('loaded')) {
            expandScmEntry(content);
            return false;
        }
        if (content.hasClass('loading')) {
            return false;
        }
        return true;
    }
  });
}(jQuery));

