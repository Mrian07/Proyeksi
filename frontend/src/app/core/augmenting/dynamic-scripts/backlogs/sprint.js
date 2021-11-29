

/***************************************
  SPRINT
***************************************/

RB.Sprint = (function ($) {
  return RB.Object.create(RB.Model, RB.EditableInplace, {

    initialize: function (el) {
      this.$ = $(el);
      this.el = el;

      // Associate this object with the element for later retrieval
      this.$.data('this', this);
      this.$.on('mouseup', '.editable', this.handleClick);
    },

    beforeSave: function () {
      // Do nothing
    },

    getType: function () {
      return "Sprint";
    },

    markIfClosed: function () {
      // Do nothing
    },

    refreshed: function () {
      // Do nothing
    },

    saveDirectives: function () {
      var j = this.$,
          data = j.find('.editor').serialize() + "&_method=put",
          url = RB.urlFor('update_sprint', { id: this.getID() });

      return {
        url : url,
        data: data
      };
    },

    beforeSaveDragResult: function () {
      // Do nothing
    }
  });
}(jQuery));
