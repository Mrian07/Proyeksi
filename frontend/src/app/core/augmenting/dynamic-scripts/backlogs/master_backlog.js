

// Initialize the backlogs after DOM is loaded
jQuery(function ($) {

  // Initialize each backlog
  $('.backlog').each(function (index) {
    // 'this' refers to an element with class="backlog"
    RB.Factory.initialize(RB.Backlog, this);
  });

  $('.backlog .toggler').on('click',function(){
    $(this).toggleClass('closed icon-arrow-up1 icon-arrow-down1');
    $(this).parents('.backlog').find('ul.stories').toggleClass('closed');
  });
});
