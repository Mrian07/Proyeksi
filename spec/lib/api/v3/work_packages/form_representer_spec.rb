

require 'spec_helper'

describe ::API::V3::WorkPackages::FormRepresenter do
  include API::V3::Utilities::PathHelper

  let(:errors) { [] }
  let(:work_package) do
    FactoryBot.build(:work_package,
                     id: 42,
                     created_at: DateTime.now,
                     updated_at: DateTime.now)
  end
  let(:current_user) do
    FactoryBot.create(:user, member_in_project: work_package.project)
  end
  let(:representer) do
    described_class.new(work_package, current_user: current_user, errors: errors)
  end

  context 'generation' do
    subject(:generated) { representer.to_json }

    it { is_expected.to be_json_eql('Form'.to_json).at_path('_type') }

    describe 'validation errors' do
      context 'w/o errors' do
        it { is_expected.to be_json_eql({}.to_json).at_path('_embedded/validationErrors') }
      end

      context 'with errors' do
        let(:subject_error_message) { 'Subject can\'t be blank!' }
        let(:status_error_message) { 'Status can\'t be blank!' }
        let(:errors) { [subject_error, status_error] }
        let(:subject_error) { ::API::Errors::Validation.new(:subject, subject_error_message) }
        let(:status_error) { ::API::Errors::Validation.new(:status, status_error_message) }
        let(:api_subject_error) { ::API::V3::Errors::ErrorRepresenter.new(subject_error) }
        let(:api_status_error) { ::API::V3::Errors::ErrorRepresenter.new(status_error) }
        let(:api_errors) { { subject: api_subject_error, status: api_status_error } }

        it { is_expected.to be_json_eql(api_errors.to_json).at_path('_embedded/validationErrors') }
      end
    end

    it { is_expected.to have_json_path('_embedded/payload') }
    it { is_expected.to have_json_path('_embedded/schema') }
  end
end
