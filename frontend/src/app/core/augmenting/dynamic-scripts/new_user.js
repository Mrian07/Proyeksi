


(function() {
  /**
   * When the user chooses the default internal authentication mode
   * no login field is shown as the email is taken by default.
   * If another mode is chosen (e.g. LDAP) the field is shown as it
   * may be required by the auth source.
   */
  var toggleLogin = function() {
    var newUserLogin = jQuery('#new_user_login');

    if (this.value === '') {
      newUserLogin.hide();
      newUserLogin.find('input').prop('disabled', true);
    } else {
      newUserLogin.show();
      newUserLogin.find('input').prop('disabled', false);
    }
  };

  jQuery(function init(){
    var select = jQuery('#user_auth_source_id');

    select.on('change.toggleNewUserLogin', toggleLogin);
  });
})();
