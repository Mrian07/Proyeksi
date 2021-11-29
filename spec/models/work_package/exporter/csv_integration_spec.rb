#-- encoding: UTF-8



require 'spec_helper'

describe WorkPackage::Exports::CSV, 'integration', type: :model do
  before do
    login_as current_user
  end

  let(:project) { FactoryBot.create(:project) }

  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i(view_work_packages))
  end
  let(:query) do
    Query.new(name: '_').tap do |query|
      query.column_names = %i(subject assigned_to updated_at estimated_hours)
    end
  end
  let(:instance) do
    described_class.new(query)
  end

  ##
  # When Ruby tries to join the following work package's subject encoded in ISO-8859-1
  # and its description encoded in UTF-8 it will result in a CompatibilityError.
  # This would not happen if the description contained only letters covered by
  # ISO-8859-1. Since this can happen, though, it is more sensible to encode everything
  # in UTF-8 which gets rid of this problem altogether.
  let!(:work_package) do
    FactoryBot.create(
      :work_package,
      subject: "Ruby encodes ß as '\\xDF' in ISO-8859-1.",
      description: "\u2022 requires unicode.",
      assigned_to: current_user,
      derived_estimated_hours: 15.0,
      project: project
    )
  end

  it 'performs a successful export' do
    work_package.reload

    data = CSV.parse instance.export!.content

    expect(data.size).to eq(2)
    expect(data.last).to include(work_package.subject)
    expect(data.last).to include(work_package.description)
    expect(data.last).to include(current_user.name)
    expect(data.last).to include(work_package.updated_at.localtime.strftime("%m/%d/%Y %I:%M %p"))
    expect(data.last).to include('(15.0)')
  end
end
