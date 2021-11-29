#-- encoding: UTF-8



require 'spec_helper'

describe WorkPackagesController, type: :controller do
  before do
    login_as current_user
  end

  let(:stub_project) { FactoryBot.build_stubbed(:project, identifier: 'test_project', public: false) }
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:work_packages) { [FactoryBot.build_stubbed(:stubbed_work_package)] }

  describe 'index' do
    let(:query) do
      FactoryBot.build_stubbed(:query)
    end

    before do
      allow(User.current).to receive(:allowed_to?).and_return(true)
      allow(controller).to receive(:retrieve_query).and_return(query)
    end

    describe 'bcf' do
      let(:mime_type) { 'bcf' }
      let(:export_storage) { FactoryBot.build_stubbed(:work_packages_export) }

      before do
        service_instance = double('service_instance')

        allow(WorkPackages::Exports::ScheduleService)
          .to receive(:new)
          .with(user: current_user)
          .and_return(service_instance)

        allow(service_instance)
          .to receive(:call)
          .with(query: query, mime_type: mime_type.to_sym, params: anything)
          .and_return(ServiceResult.new(result: 'uuid of the export job'))
      end

      it 'redirects to the export' do
        get 'index', params: { format: 'bcf' }
        expect(response).to redirect_to job_status_path('uuid of the export job')
      end

      context 'with json accept' do
        it 'should fulfill the defined should_receives' do
          request.headers['Accept'] = 'application/json'
          get 'index', params: { format: 'bcf' }
          expect(response.body).to eq({ job_id: 'uuid of the export job' }.to_json)
        end
      end
    end
  end
end
