

require "spec_helper"

describe User, "default time zone" do
  let(:user) { FactoryBot.create :user }

  context "with no system default set" do
    it "is not set" do
      expect(user.pref.time_zone).to be_nil
    end
  end

  context "with a system default set", with_settings: { user_default_timezone: "Europe/London" } do
    it "is set to the default" do
      expect(user.pref.time_zone).to eq "Europe/London"
    end
  end
end
