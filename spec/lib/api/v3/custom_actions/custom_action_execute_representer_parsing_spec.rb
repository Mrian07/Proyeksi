

require 'spec_helper'

describe ::API::V3::CustomActions::CustomActionExecuteRepresenter, 'parsing' do
  include ::API::V3::Utilities::PathHelper

  let(:struct) { OpenStruct.new }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:work_package) { FactoryBot.build_stubbed(:stubbed_work_package) }

  let(:representer) do
    described_class.new(struct, current_user: user)
  end

  let(:payload) do
    {}
  end

  subject do
    representer.from_hash(payload)

    struct
  end

  context 'lockVersion' do
    let(:payload) do
      {
        'lockVersion' => 1
      }
    end

    it 'sets the lockVersion' do
      expect(subject.lock_version)
        .to eql payload['lockVersion']
    end
  end

  context '_links' do
    context 'workPackage' do
      let(:payload) do
        {
          '_links' => {
            'workPackage' => {
              'href' => api_v3_paths.work_package(work_package.id)
            }
          }
        }
      end

      it 'sets the work_package_id' do
        expect(subject.work_package_id)
          .to eql work_package.id.to_s
      end
    end
  end
end
