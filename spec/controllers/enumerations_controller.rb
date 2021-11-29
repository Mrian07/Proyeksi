

require 'spec_helper'

describe EnumerationsController, type: :controller do
  before { allow(controller).to receive(:require_admin).and_return(true) }

  describe '#destroy' do
    describe '#priority' do
      let(:enum_to_delete) { FactoryBot.create(:priority_normal) }

      shared_examples_for 'successful delete' do
        it { expect(Enumeration.find_by(id: enum_to_delete.id)).to be_nil }

        it { expect(response).to redirect_to(enumerations_path) }
      end

      describe 'not in use' do
        before do
          post :destroy, params: { id: enum_to_delete.id }
        end

        it_behaves_like 'successful delete'
      end

      describe 'in use' do
        let!(:enum_to_reassign) { FactoryBot.create(:priority_high) }
        let!(:work_package) do
          FactoryBot.create(:work_package,
                            priority: enum_to_delete)
        end

        describe 'no reassign' do
          before do
            post :destroy, params: { id: enum_to_delete.id }
          end

          it { expect(assigns(:enumerations)).to include(enum_to_reassign) }

          it { expect(Enumeration.find_by(id: enum_to_delete.id)).not_to be_nil }

          it { expect(response).to render_template('enumerations/destroy') }
        end

        describe 'reassign' do
          before do
            post :destroy,
                 params: { id: enum_to_delete.id, reassign_to_id: enum_to_reassign.id }
          end

          it_behaves_like 'successful delete'
        end
      end
    end
  end
end
