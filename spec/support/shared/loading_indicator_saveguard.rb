

# Method to manually wait for an asynchronous request (through jQuery) to complete.
# This applies to all requests through resources as well.
#
# Note: Use this only if there are no other means of detecting the successful
# completion of said request.
#

def loading_indicator_saveguard
  expect(page).to have_no_selector('.loading-indicator')
end
