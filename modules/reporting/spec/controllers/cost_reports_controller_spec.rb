

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CostReportsController, type: :controller do
  include OpenProject::Reporting::PluginSpecHelper

  let(:user) { FactoryBot.build(:user) }
  let(:project) { FactoryBot.build(:valid_project) }

  describe "GET show" do
    before(:each) do
      is_member project, user, [:view_cost_entries]
      allow(User).to receive(:current).and_return(user)
    end

    describe "WHEN providing invalid units
              WHEN having the view_cost_entries permission" do
      before do
        get :show, params: { id: 1, unit: -1 }
      end

      it "should respond with a 404 error" do
        expect(response.code).to eql("404")
      end
    end
  end
end
