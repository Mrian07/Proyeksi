#-- encoding: UTF-8



class HighlightingController < ApplicationController
  before_action :determine_freshness
  skip_before_action :check_if_login_required, only: [:styles]

  def styles
    response.content_type = Mime[:css]
    request.format = :css

    expires_in 1.year, public: true, must_revalidate: false
    if stale?(last_modified: Time.zone.parse(@max_updated_at), etag: @highlight_version_tag, public: true)
      OpenProject::Cache.fetch('highlighting/styles', @highlight_version_tag) do
        render template: 'highlighting/styles', formats: [:css]
      end
    end
  end

  private

  def determine_freshness
    @max_updated_at = helpers.highlight_css_updated_at.to_s || Time.now.iso8601
    @highlight_version_tag = helpers.highlight_css_version_tag(@max_updated_at)
  end
end
