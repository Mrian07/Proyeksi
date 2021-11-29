

module PermissionSpecHelpers
  def spec_permissions(test_denied = true)
    describe 'w/ valid auth' do
      before { allow(User).to receive(:current).and_return valid_user }

      it 'grants access' do
        fetch

        if respond_to? :expect_redirect_to
          expect(response).to be_redirect

          case expect_redirect_to
          when true
            expect(response.redirect_url).not_to match(%r'/login')
          when Regexp
            expect(response.redirect_url).to match(expect_redirect_to)
          else
            expect(response).to redirect_to(expect_redirect_to)
          end
        elsif respond_to? :expect_no_content
          expect(response.response_code).to eq(204)
        else
          expect(response.response_code).to eq(200)
        end
      end
    end

    if test_denied
      describe 'w/o valid auth' do
        before { allow(User).to receive(:current).and_return invalid_user }

        it 'denies access' do
          fetch

          if invalid_user.logged?
            expect(response.response_code).to eq(403)
          elsif controller.send(:api_request?)
            expect(response.response_code).to eq(401)
          else
            expect(response).to be_redirect
            expect(response.redirect_url).to match(%r'/login')
          end
        end
      end
    end
  end
end

shared_examples_for 'a controller action with unrestricted access' do
  let(:valid_user) { FactoryBot.create(:anonymous) }

  extend PermissionSpecHelpers
  spec_permissions(false)
end

shared_examples_for 'a controller action with require_login' do
  let(:valid_user)   { FactoryBot.create(:user) }
  let(:invalid_user) { FactoryBot.create(:anonymous) }

  extend PermissionSpecHelpers
  spec_permissions
end

shared_examples_for 'a controller action with require_admin' do
  let(:valid_user)   { User.where(admin: true).first || FactoryBot.create(:admin) }
  let(:invalid_user) { FactoryBot.create(:user) }

  extend PermissionSpecHelpers
  spec_permissions
end

shared_examples_for 'a controller action which needs project permissions' do
  # Expecting the following environment
  #
  # let(:project) { FactoryBot.create(:project) }
  #
  # def fetch
  #   get 'action', project_id: project.identifier
  # end
  #
  # Optionally also provide the following
  #
  # let(:permission) { :edit_project }
  #
  # def expect_redirect_to
  #   # Regexp - which should match the full redirect URL
  #   # true   - action should redirect, but not to /login
  #   # other  - passed to response.should redirect_to(other)
  #   true
  # end
  let(:valid_user) { FactoryBot.create(:user) }
  let(:invalid_user) { FactoryBot.create(:user) }

  def add_membership(user, permissions)
    role   = FactoryBot.create(:role, permissions: Array(permissions))
    member = FactoryBot.build(:member, user: user, project: project)
    member.roles = [role]
    member.save!
  end

  before do
    if defined? permission
      # special permission needed - make valid_user a member with proper role,
      # invalid_user is member without special rights
      add_membership(valid_user, permission)
      add_membership(invalid_user, :view_project)
    else
      # no special permission needed - make valid_user a simple member,
      # invalid_user is non-member
      add_membership(valid_user, :view_project)
    end
  end

  extend PermissionSpecHelpers
  spec_permissions
end
