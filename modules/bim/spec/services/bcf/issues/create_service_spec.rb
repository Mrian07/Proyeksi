#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_create_service'

describe Bim::Bcf::Issues::CreateService, type: :model do
  it_behaves_like 'BaseServices create service' do
    let(:model_class) { ::Bim::Bcf::Issue }
    let(:factory) { :bcf_issue }
    let(:work_package) { FactoryBot.build_stubbed :work_package }
    let(:wp_call) { ServiceResult.new(success: true, result: work_package) }

    before do
      allow(instance)
        .to(receive(:create_work_package))
        .and_return(wp_call)
    end

    context 'when WP service call fails' do
      let(:wp_call) { ServiceResult.new(success: false, result: work_package) }

      it 'returns with that call immediately' do
        expect(subject).to eq wp_call
      end
    end
  end
end
