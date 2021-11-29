

import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { PasswordConfirmationModalComponent } from 'core-app/shared/components/modals/request-for-confirmation/password-confirmation.modal';

function registerListener(
  form:JQuery,
  $event:JQuery.TriggeredEvent,
  opModalService:OpModalService,
  modal:typeof PasswordConfirmationModalComponent,
) {
  const passwordConfirm = form.find('_password_confirmation');

  if (passwordConfirm.length > 0) {
    return true;
  }

  $event.preventDefault();
  const modalComponent = opModalService.show(modal, 'global');
  modalComponent.closingEvent.subscribe((confirmModal:any) => {
    if (confirmModal.confirmed) {
      jQuery('<input>')
        .attr({
          type: 'hidden',
          name: '_password_confirmation',
          value: confirmModal.password_confirmation,
        })
        .appendTo(form);

      form.trigger('submit');
    }
  });

  return false;
}

export function registerRequestForConfirmation($:JQueryStatic) {
  window.OpenProject
    .getPluginContext()
    .then((context) => {
      const { opModalService } = context.services;
      const passwordConfirmationModal = context.classes.modals.passwordConfirmation;

      $(document).on(
        'submit',
        'form[data-request-for-confirmation]',
        function (this:any, $event:JQuery.TriggeredEvent) {
          const form = jQuery(this);

          if (form.find('input[name="_password_confirmation"]').length) {
            return true;
          }

          return registerListener(form, $event, opModalService, passwordConfirmationModal);
        },
      );
    })
    .catch(() => {});
}
