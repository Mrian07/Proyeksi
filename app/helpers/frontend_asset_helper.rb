#-- encoding: UTF-8

module FrontendAssetHelper
  CLI_DEFAULT_PROXY = 'http://localhost:4200'.freeze

  def self.assets_proxied?
    !ENV['PROYEKSIAPP_DISABLE_DEV_ASSET_PROXY'].present? && !Rails.env.production? && cli_proxy?
  end

  def self.cli_proxy
    ENV.fetch('PROYEKSIAPP_CLI_PROXY', CLI_DEFAULT_PROXY)
  end

  def self.cli_proxy?
    cli_proxy.present?
  end

  ##
  # Include angular CLI frontend assets by either referencing a prod build,
  # or referencing the running CLI proxy that hosts the assets in memory.
  def include_frontend_assets
    capture do
      %w(vendor.js polyfills.js runtime.js main.js).each do |file|
        concat javascript_include_tag variable_asset_path(file)
      end

      concat stylesheet_link_tag variable_asset_path("styles.css"), media: :all
    end
  end

  private

  def angular_cli_asset(path)
    URI.join(FrontendAssetHelper.cli_proxy, "assets/frontend/#{path}")
  end

  def frontend_asset_path(unhashed, options = {})
    file_name = ::ProyeksiApp::Assets.lookup_asset unhashed

    asset_path "assets/frontend/#{file_name}", options.merge(skip_pipeline: true)
  end

  def variable_asset_path(path)
    if FrontendAssetHelper.assets_proxied?
      angular_cli_asset(path)
    else
      frontend_asset_path(path)
    end
  end
end
