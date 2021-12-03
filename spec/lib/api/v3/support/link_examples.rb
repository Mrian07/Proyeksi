

require 'spec_helper'

# FIXME: deprecate this example and replace by 'has an untitled action link'
# it does not work as intended (setting user has no effect, but by chance :role overrides base spec)
# it does not check the actual href/method
shared_examples_for 'action link' do
  let(:permissions) { %i(view_work_packages edit_work_packages) }
  let(:user) do
    FactoryBot.build_stubbed(:user)
  end

  let(:href) { nil }

  before do
    login_as(user)
    allow(user)
      .to receive(:allowed_to?) do |permission, _project|
      permissions.include?(permission)
    end
  end

  it { expect(subject).not_to have_json_path("_links/#{action}/href") }

  describe 'with permission' do
    before do
      permissions << permission
    end

    it { expect(subject).to have_json_path("_links/#{action}/href") }

    it do
      if href
        expect(subject).to be_json_eql(href.to_json).at_path("_links/#{action}/href")
      end
    end
  end
end

shared_context 'action link shared' do
  let(:all_permissions) { ProyeksiApp::AccessControl.permissions.map(&:name) }
  let(:permissions) { all_permissions }
  let(:action_link_user) do
    defined?(user) ? user : FactoryBot.build_stubbed(:user)
  end

  before do
    login_as(action_link_user)
    allow(action_link_user)
      .to receive(:allowed_to?) do |permission, _project|
      permissions.include?(permission)
    end
  end

  it 'indicates the desired method' do
    verb = begin
      # the standard method #method on an object interferes
      # with the let named 'method' conditionally defined
      method
    rescue ArgumentError
      :get
    end

    if verb != :get
      is_expected
        .to be_json_eql(method.to_json)
        .at_path("_links/#{link}/method")
    else
      is_expected
        .not_to have_json_path("_links/#{link}/method")
    end
  end

  describe 'without permission' do
    let(:permissions) { all_permissions - [permission] }

    it_behaves_like 'has no link'
  end
end

shared_examples_for 'has an untitled action link' do
  include_context 'action link shared'

  it_behaves_like 'has an untitled link'
end

shared_examples_for 'has a titled action link' do
  include_context 'action link shared'

  it_behaves_like 'has a titled link'
end

shared_examples_for 'has a titled link' do
  it { is_expected.to be_json_eql(href.to_json).at_path("_links/#{link}/href") }
  it { is_expected.to be_json_eql(title.to_json).at_path("_links/#{link}/title") }
end

shared_examples_for 'has an untitled link' do
  it { is_expected.to be_json_eql(href.to_json).at_path("_links/#{link}/href") }
  it { is_expected.not_to have_json_path("_links/#{link}/title") }
end

shared_examples_for 'has a templated link' do
  it { is_expected.to be_json_eql(href.to_json).at_path("_links/#{link}/href") }
  it { is_expected.to be_json_eql(true.to_json).at_path("_links/#{link}/templated") }
end

shared_examples_for 'has an empty link' do
  it { is_expected.to be_json_eql(nil.to_json).at_path("_links/#{link}/href") }

  it 'has no embedded resource' do
    is_expected.not_to have_json_path("_embedded/#{link}")
  end
end

shared_examples_for 'has an empty link collection' do
  it { is_expected.to be_json_eql([].to_json).at_path("_links/#{link}") }
end

shared_examples_for 'has a link collection' do
  it { is_expected.to be_json_eql(hrefs.to_json).at_path("_links/#{link}") }
end

shared_examples_for 'has no link' do
  it { is_expected.not_to have_json_path("_links/#{link}") }

  it 'has no embedded resource' do
    is_expected.not_to have_json_path("_embedded/#{link}")
  end
end
