#-- encoding: UTF-8



require 'spec_helper'

describe WorkPackages::ExportJob, 'Integration' do
  let(:project) { FactoryBot.create(:project) }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %w[view_work_packages export_work_packages])
  end
  let(:export) do
    FactoryBot.create(:work_packages_export)
  end
  let(:query) { FactoryBot.create(:query, name: 'Query report 04/2021 äöü', project: project) }
  let(:query_attributes) { {} }

  let(:job) { described_class.new(jobs_args) }
  let(:jobs_args) do
    {
      export: export,
      mime_type: mime_type,
      user: user,
      options: options,
      query: query,
      query_attributes: query_attributes
    }
  end
  let(:options) { {} }
  let(:mime_type) { :pdf }

  subject(:performed_job) do
    job.tap(&:perform_now)
  end

  subject(:job_status) do
    JobStatus::Status.find_by(job_id: job.job_id)
  end

  describe 'with special characters in the project title' do
    let(:project) { FactoryBot.create(:project, name: 'Foo Bla. Report No. 4/2021 with/for Case 42') }

    it 'exports the job correctly, renaming the result' do
      expect { performed_job }.not_to raise_error

      expect(job_status.status).to eq 'success'

      attachment = export.attachments.last
      expect(attachment.filename).to eq "Foo_Bla._Report_No._4-2021_with-for_Case_42_-_Query_report_04-2021_äöü.pdf"
    end
  end
end
