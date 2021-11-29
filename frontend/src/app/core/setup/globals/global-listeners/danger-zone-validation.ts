

// Moved from app/assets/javascript/danger_zone_validation.js
// Make the whole danger zone a component the next time this needs changes!
export function dangerZoneValidation() {
  // This will only work iff there is a single danger zone on the page
  const dangerZoneVerification = jQuery('.danger-zone--verification');
  const expectedValue = jQuery('.danger-zone--expected-value').text();

  dangerZoneVerification.find('input').on('input', () => {
    const actualValue = dangerZoneVerification.find('input').val() as string;
    if (expectedValue.toLowerCase() === actualValue.toLowerCase()) {
      dangerZoneVerification.find('button').prop('disabled', false);
    } else {
      dangerZoneVerification.find('button').prop('disabled', true);
    }
  });
}
