

require 'spec_helper'

describe "default query", type: :model do
  let(:query) { Query.new_default }

  describe "highlighting mode" do
    context " with highlighting mode setting", with_ee: %i[conditional_highlighting] do
      describe "not set" do
        it "is inline" do
          expect(query.highlighting_mode).to eq :inline
        end
      end

      describe "set to inline", with_settings: { work_package_list_default_highlighting_mode: "inline" } do
        it "is inline" do
          expect(query.highlighting_mode).to eq :inline
        end
      end

      describe "set to none", with_settings: { work_package_list_default_highlighting_mode: "none" } do
        it "is none" do
          expect(query.highlighting_mode).to eq :none
        end
      end

      describe "set to status", with_settings: { work_package_list_default_highlighting_mode: "status" } do
        it "is status" do
          expect(query.highlighting_mode).to eq :status
        end
      end

      describe "set to priority", with_settings: { work_package_list_default_highlighting_mode: "priority" } do
        it "is priority" do
          expect(query.highlighting_mode).to eq :priority
        end
      end

      describe "set to invalid value", with_settings: { work_package_list_default_highlighting_mode: "fubar" } do
        it "is inline" do
          expect(query.highlighting_mode).to eq :inline
        end
      end
    end
  end
end
