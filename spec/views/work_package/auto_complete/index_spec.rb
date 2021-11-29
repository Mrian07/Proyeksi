

require 'spec_helper'

describe 'work_packages/auto_completes/index.html.erb', type: :view do
  let(:work_package) do
    FactoryBot.build(:work_package,
                     subject: '<script>alert("do not alert this");</script>')
  end

  it 'escapes work package subject in auto-completion' do
    assign :work_packages, [work_package]
    render
    # there are items
    expect(rendered).to have_selector 'li'
    # but there is not script tag
    expect(rendered).not_to have_selector 'script'
    # normal text should be included
    expect(rendered).to include 'do not alert this'
  end
end
