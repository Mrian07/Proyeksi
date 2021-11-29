

# Create memberships like this:
#
#   project = FactoryBot.create(:project)
#   user    = FactoryBot.create(:user)
#   role    = FactoryBot.create(:role, permissions: [:view_wiki_pages, :edit_wiki_pages])
#
#   member = FactoryBot.create(:member, user: user, project: project)
#   member.role_ids = [role.id]
#   member.save!
#
# It looks like you cannot create member_role models directly.

FactoryBot.define do
  factory :member do
    project

    transient do
      user { nil }
    end

    callback(:after_build) do |member, options|
      member.principal ||= options.user || FactoryBot.build(:user)
    end

    callback(:after_stub) do |member, options|
      member.principal ||= options.user || FactoryBot.build_stubbed(:user)
    end
  end

  factory :global_member, parent: :member do
    project { nil }
  end
end
