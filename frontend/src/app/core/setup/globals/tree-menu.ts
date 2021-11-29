

(function ($) {
  $(() => {
    // set selected page for menu tree if provided.
    $('[data-selected-page]').closest('.tree-menu--container').each((_i:number, tree:HTMLElement) => {
      const selectedPage = $(tree).data('selected-page');

      if (selectedPage) {
        const selected = $(`[slug="${selectedPage}"]`, tree);
        selected.toggleClass('-selected', true);
        if (selected.length > 0) {
          selected[0].scrollIntoView();
        }
      }
    });

    function toggle(event:any) {
      // ignore the event if a key different from ENTER was pressed.
      if (event.type === 'keypress' && event.which !== 13) {
        return false;
      }

      const target = $(event.target);
      const targetList = target.closest('ul.-with-hierarchy > li');
      targetList.toggleClass('-hierarchy-collapsed -hierarchy-expanded');
      return false;
    }

    // set click handlers for expanding and collapsing tree nodes
    $('.pages-hierarchy.-with-hierarchy .tree-menu--hierarchy-span').on('click keypress', toggle);
  });
}(jQuery));
