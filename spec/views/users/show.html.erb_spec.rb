

require 'spec_helper'

describe 'users/show', type: :view do
  let(:project)    { FactoryBot.create :valid_project }
  let(:user)       { FactoryBot.create :admin, member_in_project: project }
  let(:custom_field) { FactoryBot.create :text_user_custom_field }
  let(:visibility_custom_value) do
    FactoryBot.create(:principal_custom_value,
                      customized: user,
                      custom_field: custom_field,
                      value: 'TextUserCustomFieldValue')
  end

  before do
    visibility_custom_value
    user.reload

    assign(:user, user)
    assign(:memberships, user.memberships)
    assign(:events_by_day, [])
  end

  it 'renders the visible custom values' do
    render

    expect(rendered).to have_selector('li', text: 'TextUserCustomField')
  end
end
