

export function refreshOnFormChanges() {
  const matches = document.querySelectorAll('.augment--refresh-on-form-changes');

  for (let i = 0; i < matches.length; i++) {
    const element = matches[i];
    const form = jQuery(element);
    const url = form.data('refreshUrl');
    const inputId = form.data('inputSelector');

    form
      .find(inputId)
      .on('change', () => {
        window.location.href = `${url}?${form.serialize()}`;
      });
  }
}
