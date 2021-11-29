#-- encoding: UTF-8



require 'spec_helper'

describe WorkPackages::ExportJob do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:attachment) { double('Attachment', id: 1234) }
  let(:export) do
    FactoryBot.build_stubbed(:work_packages_export)
  end
  let(:query) { FactoryBot.build_stubbed(:query) }

  let(:job) { described_class.new(jobs_args) }
  let(:jobs_args) do
    {
      export: export,
      mime_type: mime_type,
      user: user,
      options: {},
      query: query,
      query_attributes: {}
    }
  end

  subject do
    job.tap(&:perform_now)
  end

  describe '#perform' do
    context 'with the bcf mime type' do
      let(:mime_type) { :bcf }
      let(:exporter) { OpenProject::Bim::BcfXml::Exporter }
      let(:exporter_instance) { instance_double(exporter) }

      it 'issues an OpenProject::Bim::BcfXml::Exporter export' do
        result = Exports::Result.new(format: 'blubs',
                                     title: "some_title.#{mime_type}",
                                     content: 'some content',
                                     mime_type: "application/octet-stream")

        service = double('attachments create service')

        expect(Attachments::CreateService)
          .to receive(:bypass_whitelist)
                .with(user: user)
                .and_return(service)

        expect(Exports::CleanupOutdatedJob)
          .to receive(:perform_after_grace)

        expect(service)
          .to(receive(:call))
          .and_return(ServiceResult.new(result: attachment, success: true))

        allow(exporter).to receive(:new).and_return(exporter_instance)
        allow(exporter_instance).to receive(:export!).and_return(result)

        # expect to create a status
        expect(subject.job_status).to be_present
        expect(subject.job_status[:status]).to eq 'success'
        expect(subject.job_status[:payload]['download']).to eq '/api/v3/attachments/1234/content'
      end
    end
  end
end
