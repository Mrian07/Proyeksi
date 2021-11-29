


(function() {
  // When 'assign random password' field is enabled,
  // disable and clear password fields and disable and check the
  // 'force password reset' field
  function on_assign_random_password_change(){
    var checked = jQuery('#user_assign_random_password').is(':checked');
    jQuery('#user_password').prop('disabled', checked);
    jQuery('#user_password_confirmation').prop('disabled', checked);
    jQuery('#user_password').val('');
    jQuery('#user_password_confirmation').val('');
    jQuery('#user_force_password_change').prop('checked', checked)
                                         .prop('disabled', checked);
  }

  /**
   * Hide password fields when non-internal authentication source is selected.
   * Also disables the fields so they are not submitted and not required to
   * enter.
   */
  function on_auth_source_change() {
    var passwordFields = jQuery('#password_fields'),
        passwordInputs = passwordFields.find('#user_password, #user_password_confirmation');

    if (this.value === '') {
      passwordFields.show();
      passwordInputs.prop('disabled', false);
    } else {
      passwordFields.hide();
      passwordInputs.prop('disabled', 'disabled');
    }
  }

  function on_password_change() {
    var sendInformationField =  jQuery('.send-information');
    sendInformationField.toggleClass('-hidden', jQuery(this).val() === '');
  }

  jQuery(function init(){
    jQuery('#user_assign_random_password').change(on_assign_random_password_change);
    jQuery('#user_auth_source_id').on('change.togglePasswordFields', on_auth_source_change);
    jQuery('#user_password').change(on_password_change);
  });
})();
