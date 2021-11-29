

# Ensure the page is completely loaded before the spec is run.
# The status filter is loaded very late in the page setup.
shared_context 'ensure wp details pane update done' do
  after do
    unless update_user
      raise "Expect to have a let called 'update_user' defining which user \
             is doing the update".squish
    end

    # safeguard to ensure all backend queries
    # have been answered before starting a new spec
    expect(page).to have_selector('.op-user-activity--user-name',
                                  text: update_user.name)
  end
end
