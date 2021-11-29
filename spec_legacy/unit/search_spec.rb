#-- encoding: UTF-8


require_relative '../legacy_spec_helper'

describe 'Search' do # FIXME: naming (RSpec-port)
  fixtures :all

  before do
    @project = Project.find(1)
    @issue_keyword = '%unable to print recipes%'
    @issue = WorkPackage.find(1)
    @changeset_keyword = '%very first commit%'
    @changeset = Changeset.find(100)
  end

  it 'should search_by_anonymous' do
    User.current = nil

    r = WorkPackage.search(@issue_keyword).first
    assert r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert r.include?(@changeset)

    # Removes the :view_changesets permission from Anonymous role
    remove_permission Role.anonymous, :view_changesets

    r = WorkPackage.search(@issue_keyword).first
    assert r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert !r.include?(@changeset)

    # Make the project private
    @project.update_attribute :public, false
    r = WorkPackage.search(@issue_keyword).first
    assert !r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert !r.include?(@changeset)
  end

  it 'should search_by_user' do
    User.current = User.find_by_login('rhill')
    assert User.current.memberships.empty?

    r = WorkPackage.search(@issue_keyword).first
    assert r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert r.include?(@changeset)

    # Removes the :view_changesets permission from Non member role
    remove_permission Role.non_member, :view_changesets

    r = WorkPackage.search(@issue_keyword).first
    assert r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert !r.include?(@changeset)

    # Make the project private
    @project.update_attribute :public, false
    r = WorkPackage.search(@issue_keyword).first
    assert !r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert !r.include?(@changeset)
  end

  it 'should search_by_allowed_member' do
    User.current = User.find_by_login('jsmith')
    assert User.current.projects.include?(@project)

    r = WorkPackage.search(@issue_keyword).first
    assert r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert r.include?(@changeset)

    # Make the project private
    @project.update_attribute :public, false
    r = WorkPackage.search(@issue_keyword).first
    assert r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert r.include?(@changeset)
  end

  it 'should search_by_unallowed_member' do
    # Removes the :view_changesets permission from user's and non member role
    remove_permission Role.find(1), :view_changesets
    remove_permission Role.non_member, :view_changesets

    User.current = User.find_by_login('jsmith')
    assert User.current.projects.include?(@project)

    r = WorkPackage.search(@issue_keyword).first
    assert r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert !r.include?(@changeset)

    # Make the project private
    @project.update_attribute :public, false
    r = WorkPackage.search(@issue_keyword).first
    assert r.include?(@issue)
    r = Changeset.search(@changeset_keyword).first
    assert !r.include?(@changeset)
  end

  it 'should search_issue_with_multiple_hits_in_journals' do
    i = WorkPackage.find(1)
    Journal.where(journable_id: i.id).delete_all
    i.add_journal User.current, 'Journal notes'
    i.save!
    i.add_journal User.current, 'Some notes with Redmine links: #2, r2.'
    i.save!

    assert_equal 2, i.journals.where("notes LIKE '%notes%'").count

    r = WorkPackage.search('%notes%').first
    assert_equal 1, r.size
    assert_equal i, r.first
  end

  private

  def remove_permission(role, permission)
    role.permissions = role.permissions - [permission]
    role.save
  end
end
