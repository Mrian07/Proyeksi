
require "#{File.dirname(__FILE__)}/../spec_helper"

describe GithubUser do
  describe "validations" do
    it { is_expected.to validate_presence_of :github_id }
    it { is_expected.to validate_presence_of :github_login }
    it { is_expected.to validate_presence_of :github_html_url }
    it { is_expected.to validate_presence_of :github_avatar_url }
  end
end
