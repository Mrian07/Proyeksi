
require "#{File.dirname(__FILE__)}/../spec_helper"

describe GithubCheckRun do
  describe "validations" do
    it { is_expected.to validate_presence_of :github_app_owner_avatar_url }
    it { is_expected.to validate_presence_of :github_html_url }
    it { is_expected.to validate_presence_of :github_id }
    it { is_expected.to validate_presence_of :status }
  end
end
