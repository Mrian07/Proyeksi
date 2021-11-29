#-- encoding: UTF-8


require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    # As we're using WebMock to mock and test remote HTTP requests,
    # we require specs to selectively enable mocking of Net::HTTP et al. when the example desires.
    # Otherwise, all requests are being mocked by default.
    WebMock.disable!
  end

  config.around(:example, webmock: true) do |example|
    # When we enable webmock, no connections other than stubbed ones are allowed.
    # We will exempt local connections from this block, since selenium etc.
    # uses localhost to communicate with the browser.
    # Leaving this off will randomly fail some specs with WebMock::NetConnectNotAllowedError
    WebMock.disable_net_connect!(allow_localhost: true, allow: ["selenium-hub", Capybara.server_host])
    WebMock.enable!
    example.run
  ensure
    WebMock.allow_net_connect!
    WebMock.disable!
  end
end
