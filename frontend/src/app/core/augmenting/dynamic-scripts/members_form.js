

function findFilter() {
  var filter =  jQuery('.simple-filters--container');

  // Find the filter elements on the page
  if(filter.length === 0)
    filter = jQuery('.advanced-filters--container');
  else if(filter.length === 0)
    filter = nil;

  return filter;
}

function hideFilter(filter) {
  filter.addClass('collapsed');
}

function showFilter(filter) {
  filter.removeClass('collapsed');
}

function toggleMemberFilter() {
  if (window.OpenProject.guardedLocalStorage("showFilter") === "true") {
    window.OpenProject.guardedLocalStorage("showFilter", 'false');
    hideFilter(filter);
    jQuery('#filter-member-button').removeClass('-active');
  }
  else {
    window.OpenProject.guardedLocalStorage("showFilter", 'true');
    showFilter(filter);
    jQuery('#filter-member-button').addClass('-active');
    hideAddMemberForm();
    jQuery('.simple-filters--filter:first-of-type select').focus();
  }
}

function showAddMemberForm() {
  jQuery('#members_add_form').css('display', 'block');
  jQuery('#members_add_form #principal_search').focus();
  hideFilter(filter = findFilter());
  jQuery('#filter-member-button').removeClass('-active');
  window.OpenProject.guardedLocalStorage("showFilter", 'false');
  jQuery('#add-member-button').prop('disabled', true);

  jQuery("input#member_user_ids").on("change", function() {
    var values = jQuery("input#member_user_ids").val();

    if (values.indexOf("@") != -1) {
      jQuery("#member-user-limit-warning").css("display", "block");
    } else {
      jQuery("#member-user-limit-warning").css("display", "none");
    }
  });
}

function hideAddMemberForm() {
  jQuery('#members_add_form').css('display', 'none');
  jQuery('#add-member-button').focus();
  jQuery('#add-member-button').prop('disabled', false);
}

jQuery(document).ready(function($) {
  // Show/Hide content when page is loaded
  if (window.OpenProject.guardedLocalStorage("showFilter") === "true") {
    showFilter(filter = findFilter());
  }
  else {
    hideFilter(filter = findFilter());
    // In case showFilter is not set yet
    window.OpenProject.guardedLocalStorage("showFilter", 'false');
  }

  // Toggle filter
  $('.toggle-member-filter-link').click(toggleMemberFilter);



  // Toggle editing row
  $('.toggle-membership-button').click(function() {
    var el = $(this);
    $(el.data('toggleTarget')).toggle();
    return false;
  });

  // Show add member form
  $('#add-member-button').click(showAddMemberForm);

  // Hide member form
  $('.hide-member-form-button').click(hideAddMemberForm);

  // show member form only when there's an error
  if (jQuery("#errorExplanation").text() != "") {
    showAddMemberForm();
  }

  if (jQuery('#add-member-button').attr('data-trigger-initially')) {
    showAddMemberForm();
  }
});
