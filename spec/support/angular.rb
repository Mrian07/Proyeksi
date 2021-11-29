

##
# Wait for the angular bootstrap to have happened
def expect_angular_frontend_initialized
  expect(page).to have_selector('.__ng2-bootstrap-has-run', wait: 20)
end
