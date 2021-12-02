

require 'spec_helper'

describe 'users/index', type: :view do
  shared_let(:admin) { FactoryBot.create :admin }
  let!(:user) { FactoryBot.create :user, firstname: "Scarlet", lastname: "Scallywag" }

  before do
    User.system # create system user which is active but should not count towards limit

    assign(:users, User.where(id: [admin.id, user.id]))
    assign(:status, "all")
    assign(:groups, Group.all)

    allow(view).to receive(:current_user).and_return(admin)

    allow_any_instance_of(TableCell).to receive(:controller_name).and_return("users")
    allow_any_instance_of(TableCell).to receive(:action_name).and_return("index")
  end

  subject { rendered.squish }

  it 'renders the user table' do
    render

    is_expected.to have_text("#{admin.firstname}   #{admin.lastname}")
    is_expected.to have_text("Scarlet   Scallywag")
  end

  context "with an Enterprise token" do
    before do
      allow(ProyeksiApp::Enterprise).to receive(:token).and_return(Struct.new(:restrictions).new({ active_user_count: 5 }))
    end

    it "shows the current number of active and allowed users" do
      render

      # expected active users: admin and user from above
      is_expected.to have_text("2/5 booked active users")
    end
  end

  context "without an Enterprise token" do
    it "does not show the current number of active and allowed users" do
      render

      is_expected.not_to have_text("booked active users")
    end
  end
end
