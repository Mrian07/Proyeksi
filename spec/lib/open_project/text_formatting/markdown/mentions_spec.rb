

require 'spec_helper'
require_relative './expected_markdown'

describe OpenProject::TextFormatting,
         'mentions' do
  include_context 'expected markdown modules'

  describe '.format_text' do
    shared_let(:project) { FactoryBot.create :valid_project }
    let(:identifier) { project.identifier }
    shared_let(:role) do
      FactoryBot.create :role,
                        permissions: %i(view_work_packages edit_work_packages
                                        browse_repository view_changesets view_wiki_pages)
    end

    shared_let(:project_member) do
      FactoryBot.create :user,
                        member_in_project: project,
                        member_through_role: role
    end

    before do
      login_as(project_member)
    end

    let(:options) { { project: project } }

    context 'User links' do
      let(:role) do
        FactoryBot.create :role,
                          permissions: %i[view_work_packages edit_work_packages
                                          browse_repository view_changesets view_wiki_pages]
      end

      let(:linked_project_member) do
        FactoryBot.create :user,
                          member_in_project: project,
                          member_through_role: role
      end

      context 'User link via mention' do
        context 'existing user' do
          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                <mention class="mention"
                         data-id="#{linked_project_member.id}"
                         data-type="user"
                         data-text="@#{linked_project_member.name}">
                   @#{linked_project_member.name}
                </mention>
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  #{link_to(linked_project_member.name,
                            { controller: :users, action: :show, id: linked_project_member.id },
                            title: "User #{linked_project_member.name}",
                            class: 'user-mention op-uc-link')}
                </p>
              EXPECTED
            end
          end
        end

        context 'inexistent user' do
          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                <mention class="mention"
                         data-id="#{linked_project_member.id + 5}"
                         data-type="user"
                         data-text="@Some non existing user">
                   @Some none existing user
                </mention>
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  @Some none existing user
                </p>
              EXPECTED
            end
          end
        end
      end

      context 'User link via ID' do
        context 'when linked user visible for reader' do
          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                user##{linked_project_member.id}
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  #{link_to(linked_project_member.name,
                            { controller: :users, action: :show, id: linked_project_member.id },
                            title: "User #{linked_project_member.name}",
                            class: 'user-mention op-uc-link')}
                </p>
              EXPECTED
            end
          end
        end

        context 'when linked user not visible for reader' do
          let(:role) { FactoryBot.create(:non_member) }

          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                user##{linked_project_member.id}
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  #{link_to(linked_project_member.name,
                            { controller: :users, action: :show, id: linked_project_member.id },
                            title: "User #{linked_project_member.name}",
                            class: 'user-mention op-uc-link')}
                </p>
              EXPECTED
            end
          end
        end
      end

      context 'User link via login name' do
        context 'when linked user visible for reader' do
          context 'with a common login name' do
            it_behaves_like 'format_text produces' do
              let(:raw) do
                <<~RAW
                  user:"#{linked_project_member.login}"
                RAW
              end

              let(:expected) do
                <<~EXPECTED
                  <p class="op-uc-p">
                    #{link_to(linked_project_member.name,
                              { controller: :users, action: :show, id: linked_project_member.id },
                              title: "User #{linked_project_member.name}",
                              class: 'user-mention op-uc-link')}
                  </p>
                EXPECTED
              end
            end
          end

          context "with an email address as login name" do
            let(:linked_project_member) do
              FactoryBot.create :user,
                                member_in_project: project,
                                member_through_role: role,
                                login: "foo@bar.com"
            end

            it_behaves_like 'format_text produces' do
              let(:raw) do
                <<~RAW
                  user:"#{linked_project_member.login}"
                RAW
              end

              let(:expected) do
                <<~EXPECTED
                  <p class="op-uc-p">
                    #{link_to(linked_project_member.name,
                              { controller: :users, action: :show, id: linked_project_member.id },
                              title: "User #{linked_project_member.name}",
                              class: 'user-mention op-uc-link')}
                  </p>
                EXPECTED
              end
            end
          end
        end

        context 'when linked user not visible for reader' do
          let(:role) { FactoryBot.create(:non_member) }

          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                user:"#{linked_project_member.login}"
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  #{link_to(linked_project_member.name,
                            { controller: :users, action: :show, id: linked_project_member.id },
                            title: "User #{linked_project_member.name}",
                            class: 'user-mention op-uc-link')}
                </p>
              EXPECTED
            end
          end
        end
      end

      context 'User link via mail' do
        context 'for user references not existing' do
          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                Link to user:"foo@bar.com"
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  Link to user:"<a class="op-uc-link" href="mailto:foo@bar.com">foo@bar.com</a>"
                </p>
              EXPECTED
            end
          end
        end

        context 'when visible user exists' do
          let(:project) { FactoryBot.create :project }
          let(:role) { FactoryBot.create(:role, permissions: %i(view_work_packages)) }
          let(:current_user) do
            FactoryBot.create(:user,
                              member_in_project: project,
                              member_through_role: role)
          end
          let(:user) do
            FactoryBot.create(:user,
                              login: 'foo@bar.com',
                              firstname: 'Foo',
                              lastname: 'Barrit',
                              member_in_project: project,
                              member_through_role: role)
          end

          before do
            user
            login_as current_user
          end

          context 'with only_path true (default)' do
            it_behaves_like 'format_text produces' do
              let(:raw) do
                <<~RAW
                  Link to user:"foo@bar.com"
                RAW
              end

              let(:expected) do
                <<~EXPECTED
                  <p class="op-uc-p">
                    Link to <a class="user-mention op-uc-link" href="/users/#{user.id}" title="User Foo Barrit">Foo Barrit</a>
                  </p>
                EXPECTED
              end
            end
          end

          context 'with only_path false (default)', with_settings: { host_name: "openproject.org" } do
            let(:options) { { only_path: false } }
            it_behaves_like 'format_text produces' do
              let(:raw) do
                <<~RAW
                  Link to user:"foo@bar.com"
                RAW
              end

              let(:expected) do
                <<~EXPECTED
                  <p class="op-uc-p">
                    Link to <a class="user-mention op-uc-link" href="http://openproject.org/users/#{user.id}" title="User Foo Barrit">Foo Barrit</a>
                  </p>
                EXPECTED
              end
            end
          end
        end
      end
    end

    context 'Group reference' do
      let(:role) do
        FactoryBot.create :role,
                          permissions: []
      end

      let(:linked_project_member_group) do
        FactoryBot.create(:group).tap do |group|
          FactoryBot.create(:member,
                            principal: group,
                            project: project,
                            roles: [role])
        end
      end

      context 'via hash syntax' do
        context 'group exists' do
          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                Link to group##{linked_project_member_group.id}
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  Link to
                  <a class="user-mention op-uc-link"
                     href="/groups/#{linked_project_member_group.id}"
                     title="Group #{linked_project_member_group.name}">
                    #{linked_project_member_group.name}
                  </a>
                </p>
              EXPECTED
            end
          end
        end

        context 'group does not exist' do
          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                Link to group#000000
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  Link to group#000000
                </p>
              EXPECTED
            end
          end
        end
      end

      context 'via mention' do
        context 'existing group' do
          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                <mention class="mention"
                         data-id="#{linked_project_member_group.id}"
                         data-type="group"
                         data-text="@#{linked_project_member_group.name}">@#{linked_project_member_group.name}</mention>
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  <a class="user-mention op-uc-link"
                     href="/groups/#{linked_project_member_group.id}"
                     title="Group #{linked_project_member_group.name}">
                    #{linked_project_member_group.name}
                  </a>
                </p>
              EXPECTED
            end
          end
        end

        context 'inexistent group' do
          it_behaves_like 'format_text produces' do
            let(:raw) do
              <<~RAW
                <mention class="mention"
                         data-id="0"
                         data-type="group"
                         data-text="@Some none existing group">
                  @Some none existing group
                </mention>
              RAW
            end

            let(:expected) do
              <<~EXPECTED
                <p class="op-uc-p">
                  @Some none existing group
                </p>
              EXPECTED
            end
          end
        end
      end
    end
  end
end
