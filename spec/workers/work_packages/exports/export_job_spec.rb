#-- encoding: UTF-8



require 'spec_helper'

describe WorkPackages::ExportJob do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:attachment) { double('Attachment', id: 1234) }
  let(:export) do
    FactoryBot.create(:work_packages_export)
  end
  let(:query) { FactoryBot.build_stubbed(:query) }
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

  subject do
    job.tap(&:perform_now)
  end

  shared_examples_for 'exporter returning string' do
    let(:result) do
      Exports::Result.new(format: 'blubs',
                          title: "some_title.#{mime_type}",
                          content: 'some string',
                          mime_type: "application/octet-stream")
    end

    let(:service) { double('attachments create service') } # rubocop:disable RSpec/VerifiedDoubles
    let(:exporter_instance) { instance_double(exporter) }

    it 'exports' do
      expect(Attachments::CreateService)
        .to receive(:bypass_whitelist)
              .with(user: user)
              .and_return(service)

      expect(Exports::CleanupOutdatedJob)
        .to receive(:perform_after_grace)

      expect(service)
        .to receive(:call) do |file:, **args|
        expect(File.basename(file))
          .to start_with 'some_title'

        expect(File.basename(file))
          .to end_with ".#{mime_type}"

        ServiceResult.new(result: attachment, success: true)
      end

      allow(exporter).to receive(:new).and_return exporter_instance

      allow(exporter_instance).to receive(:export!).and_return(result)

      # expect to create a status
      expect(subject.job_status).to be_present
      expect(subject.job_status.reference).to eq export
      expect(subject.job_status[:status]).to eq 'success'
      expect(subject.job_status[:payload]['download']).to eq '/api/v3/attachments/1234/content'
    end
  end

  describe 'query passing' do
    context 'passing in group_by through attributes' do
      let(:query_attributes) { { group_by: 'assigned_to' } }
      let(:mime_type) { :pdf }
      let(:exporter) { WorkPackage::PDFExport::WorkPackageListToPdf }

      it 'updates the query from attributes' do
        allow(exporter)
          .to receive(:new) do |query, _options|
          expect(query.group_by).to eq 'assigned_to'
        end
          .and_call_original

        subject
      end
    end
  end

  describe '#perform' do
    context 'with the pdf mime type' do
      let(:mime_type) { :pdf }
      let(:exporter) { WorkPackage::PDFExport::WorkPackageListToPdf }

      it_behaves_like 'exporter returning string'
    end

    context 'with the csv mime type' do
      let(:mime_type) { :csv }
      let(:exporter) { WorkPackage::Exports::CSV }

      it_behaves_like 'exporter returning string'
    end
  end
end
