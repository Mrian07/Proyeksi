

RB.EditableInplace = (function ($) {
  return RB.Object.create(RB.Model, {

    displayEditor: function (editor) {
      this.$.addClass("editing");
      editor.find(".editor").bind('keydown', this.handleKeydown);
    },

    getEditor: function () {
      // Create the model editor container if it does not yet exist
      var editor = this.$.children(".editors");

      if (editor.length === 0) {
        editor = $("<div class='editors'></div>").appendTo(this.$);
      } else if (!editor.hasClass('permanent')) {
        editor.first().html('');
      }
      return editor;
    },

    // For detecting Enter and ESC
    handleKeydown: function (e) {
      var j, that;

      j = $(this).parents('.model').first();
      that = j.data('this');

      // 13 is the key code of Enter, 27 of ESC.
      if (e.which === 13) {
        that.saveEdits();
      } else if (e.which === 27) {
        that.cancelEdit();
      } else {
        return true;
      }
    }
  });
}(jQuery));
