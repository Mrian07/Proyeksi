#-- encoding: UTF-8



require File.expand_path('shared/become_member', __dir__)

module PermissionSpecs
  def self.included(base)
    base.class_eval do
      let(:project) { FactoryBot.create(:project, public: false) }
      let(:current_user) { FactoryBot.create(:user) }

      include BecomeMember

      def self.check_permission_required_for(controller_action, permission)
        controller_name, action_name = controller_action.split('#')

        it "should allow calling #{controller_action} when having the permission #{permission} permission" do
          become_member_with_permissions(project, current_user, permission)

          expect(controller.send(:authorize, controller_name, action_name)).to be_truthy
        end

        it "should prevent calling #{controller_action} when not having the permission #{permission} permission" do
          become_member_with_permissions(project, current_user)

          expect(controller.send(:authorize, controller_name, action_name)).to be_falsey
        end
      end

      before do
        # As failures generate a response we need to prevent calls to nil
        controller.response = ActionDispatch::TestResponse.new

        allow(User).to receive(:current).and_return(current_user)

        controller.instance_variable_set(:@project, project)
      end
    end
  end
end
