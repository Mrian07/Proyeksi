

require 'spec_helper'

describe 'Settings', type: :feature do
  let(:admin) { FactoryBot.create(:admin) }

  describe 'subsection' do
    before do
      login_as(admin)

      visit '/admin/settings/api'
    end

    shared_examples "it can be visited" do
      let(:section) { raise "define me" }

      before do
        visit "/admin/settings/#{section}"
      end

      it "can be visited" do
        expect(page).to have_content(/#{section}/i)
      end
    end

    describe "general" do
      it_behaves_like "it can be visited" do
        let(:section) { "general" }
      end
    end

    describe "API (regression #34938)" do
      it_behaves_like "it can be visited" do
        let(:section) { "api" }
      end
    end
  end
end
