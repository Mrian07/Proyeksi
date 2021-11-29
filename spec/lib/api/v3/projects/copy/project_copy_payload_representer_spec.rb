

require 'spec_helper'

describe ::API::V3::Projects::Copy::ProjectCopyPayloadRepresenter do
  shared_let(:current_user, reload: false) { FactoryBot.build_stubbed(:user) }
  shared_let(:project, reload: false) { FactoryBot.build_stubbed(:project) }

  describe 'generation' do
    let(:meta) { OpenStruct.new }
    let(:representer) do
      described_class.create(project,
                             meta: meta,
                             current_user: current_user)
    end
    subject { representer.to_json }

    it 'has a _meta property with the copy properties set to true by default' do
      is_expected.to have_json_path '_meta'

      is_expected
        .to be_json_eql(true.to_json)
              .at_path("_meta/sendNotifications")

      ::Projects::CopyService.copyable_dependencies.each do |dep|
        is_expected
          .to be_json_eql(true.to_json)
                .at_path("_meta/copy#{dep[:identifier].camelize}")
      end
    end

    context 'with the meta property containing which associations to copy' do
      let(:meta) { OpenStruct.new only: %[work_packages wiki] }

      it 'renders only the selected dependencies as true' do
        ::Projects::CopyService.copyable_dependencies.each do |dep|
          is_expected
            .to be_json_eql(meta.only.include?(dep[:identifier].to_s).to_json)
                  .at_path("_meta/copy#{dep[:identifier].camelize}")
        end
      end
    end

    context 'with the meta property to send notifications disabled' do
      let(:meta) { OpenStruct.new send_notifications: false }

      it 'renders only the selected dependencies as true' do
        is_expected
          .to be_json_eql(false.to_json)
                .at_path("_meta/sendNotifications")
      end
    end
  end

  describe 'parsing' do
    let(:representer) do
      described_class.create(OpenStruct.new(available_custom_fields: []),
                             meta: OpenStruct.new,
                             current_user: current_user)
    end
    subject { representer.from_hash parsed_hash }

    context 'with meta set' do
      let(:parsed_hash) do
        {
          'name' => 'The copied project',
          '_meta' => {
            'copyWorkPackages' => true,
            'copyWiki' => true,
            'sendNotifications' => false
          }
        }
      end

      it 'sets all of them to true' do
        expect(subject.name).to eq 'The copied project'
        expected_names = ::Projects::CopyService.copyable_dependencies.map { |dep| dep[:identifier] }
        expect(subject.meta.only).to match_array(expected_names)
        expect(subject.meta.send_notifications).to eq false
      end
    end

    context 'with one meta copy set to false' do
      let(:parsed_hash) do
        {
          'name' => 'The copied project',
          '_meta' => {
            'copyWorkPackages' => false
          }
        }
      end

      it 'sets all others to true' do
        expect(subject.name).to eq 'The copied project'
        expected_names = ::Projects::CopyService.copyable_dependencies.map { |dep| dep[:identifier] }
        expect(subject.meta.only).to match_array(expected_names - %w[work_packages])
      end
    end

    context 'with a mixture of meta copy set to false' do
      let(:parsed_hash) do
        {
          'name' => 'The copied project',
          '_meta' => {
            'copyWorkPackages' => false,
            'copyWiki' => true,
          }
        }
      end

      it 'still sets all of them to true except work packages' do
        expect(subject.name).to eq 'The copied project'
        expected_names = ::Projects::CopyService.copyable_dependencies.map { |dep| dep[:identifier] }
        expect(subject.meta.only).to match_array(expected_names - %w[work_packages])
      end
    end

    context 'with meta unset' do
      let(:parsed_hash) do
        {
          'name' => 'The copied project',
        }
      end

      it 'does not set meta' do
        expect(subject.name).to eq 'The copied project'
        expect(subject.meta).to be_nil
      end
    end
  end
end
