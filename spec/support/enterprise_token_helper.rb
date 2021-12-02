

module AuthenticationHelpers
  def with_enterprise_token(*features)
    allow(EnterpriseToken)
      .to receive(:allows_to?)
      .and_return(false)

    if features.compact.length > 0
      features.each do |feature|
        allow(EnterpriseToken)
          .to receive(:allows_to?)
          .with(feature)
          .and_return(true)
      end

      allow(EnterpriseToken).to receive(:show_banners?).and_return(false)
    else
      allow(EnterpriseToken).to receive(:show_banners?).and_return(true)
    end

    allow(ProyeksiApp::Configuration).to receive(:ee_manager_visible?).and_return(false)
  end

  def without_enterprise_token
    # Calling without params means no EE features are allowed.
    with_enterprise_token
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers
end
