

require 'spec_helper'

describe SecurityBadgeHelper, type: :helper do
  describe '#security_badge_url' do
    before do
      # can't use with_settings since Setting.installation_uuid has a custom implementation
      allow(Setting).to receive(:installation_uuid).and_return 'abcd1234'
    end

    it "generates a URL with the release API path and the details of the installation" do
      uri = URI.parse(helper.security_badge_url)
      query = Rack::Utils.parse_nested_query(uri.query)
      expect(uri.host).to eq("releases.openproject.com")
      expect(query.keys).to match_array(["uuid", "type", "version", "db", "lang", "ee"])
      expect(query["uuid"]).to eq("abcd1234")
      expect(query["version"]).to eq(OpenProject::VERSION.to_semver)
      expect(query["type"]).to eq("manual")
      expect(query["ee"]).to eq("false")
    end
  end
end
