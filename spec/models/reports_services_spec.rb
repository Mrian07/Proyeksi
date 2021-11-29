

require 'spec_helper'

describe Reports::ReportsService, type: :model do
  let(:project) { FactoryBot.create(:project) }

  it 'should be initializable with a project' do
    expect { Reports::ReportsService.new(project) }.not_to raise_error
  end

  it 'should raise an error, when given no project' do
    expect { Reports::ReportsService.new(nil) }.to raise_error("You must provide a project to report upon")
  end
end
