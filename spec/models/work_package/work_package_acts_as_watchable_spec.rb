

require 'spec_helper'

require 'support/shared/acts_as_watchable'

describe WorkPackage, type: :model do
  let(:project) { FactoryBot.create(:project) }
  let(:work_package) do
    FactoryBot.create(:work_package,
                      project: project)
  end

  it_behaves_like 'acts_as_watchable included' do
    let(:model_instance) { FactoryBot.create(:work_package) }
    let(:watch_permission) { :view_work_packages }
    let(:project) { model_instance.project }
  end
end
