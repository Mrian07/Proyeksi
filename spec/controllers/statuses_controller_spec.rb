

require 'spec_helper'

describe StatusesController, type: :controller do
  shared_let(:user) { FactoryBot.create(:admin) }
  shared_let(:status) { FactoryBot.create(:status) }

  before { login_as(user) }

  shared_examples_for :response do
    subject { response }

    it { is_expected.to be_successful }

    it { is_expected.to render_template(template) }
  end

  shared_examples_for :redirect do
    subject { response }

    it { is_expected.to be_redirect }

    it { is_expected.to redirect_to(action: :index) }
  end

  shared_examples_for :statuses do
    subject { Status.find_by(name: name) }

    it { is_expected.not_to be_nil }
  end

  describe '#index' do
    let(:template) { 'index' }

    before { get :index }

    it_behaves_like :response
  end

  describe '#new' do
    let(:template) { 'new' }

    before { get :new }

    it_behaves_like :response
  end

  describe '#create' do
    let(:name) { 'New Status' }

    before do
      post :create,
           params: { status: { name: name } }
    end

    it_behaves_like :statuses

    it_behaves_like :redirect
  end

  describe '#edit' do
    let(:template) { 'edit' }

    context 'default' do
      let!(:status_default) do
        FactoryBot.create(:status,
                          is_default: true)
      end

      before do
        get :edit,
            params: { id: status_default.id }
      end

      it_behaves_like :response

      describe '#view' do
        render_views

        it do
          assert_select 'p',
                        { content: Status.human_attribute_name(:is_default) },
                        false
        end
      end
    end

    context 'no_default' do
      before do
        status

        get :edit, params: { id: status.id }
      end

      it_behaves_like :response

      describe '#view' do
        render_views

        it do
          assert_select 'div',
                        content: Status.human_attribute_name(:is_default)
        end
      end
    end
  end

  describe '#update' do
    let(:name) { 'Renamed Status' }

    before do
      status

      patch :update,
            params: {
              id: status.id,
              status: { name: name }
            }
    end

    it_behaves_like :statuses

    it_behaves_like :redirect
  end

  describe '#destroy' do
    let(:name) { status.name }

    shared_examples_for :destroyed do
      subject { Status.find_by(name: name) }

      it { is_expected.to be_nil }
    end

    context 'unused' do
      before do
        delete :destroy, params: { id: status.id }
      end

      it_behaves_like :destroyed

      it_behaves_like :redirect

      after do
        Status.delete_all
      end
    end

    context 'used' do
      let(:work_package) do
        FactoryBot.create(:work_package,
                          status: status)
      end

      before do
        work_package

        delete :destroy, params: { id: status.id }
      end

      it_behaves_like :statuses

      it_behaves_like :redirect
    end

    context 'default' do
      let!(:status_default) do
        FactoryBot.create(:status,
                          is_default: true)
      end

      before do
        delete :destroy, params: { id: status_default.id }
      end

      it_behaves_like :statuses

      it_behaves_like :redirect

      it 'shows the right flash message' do
        expect(flash[:error]).to eq(I18n.t('error_unable_delete_default_status'))
      end
    end
  end

  describe '#update_work_package_done_ratio' do
    shared_examples_for :flash do
      it { is_expected.to set_flash.to(message) }
    end

    context "with 'work_package_done_ratio' using 'field'" do
      let(:message) { /not updated/ }

      before do
        allow(Setting).to receive(:work_package_done_ratio).and_return 'field'

        post :update_work_package_done_ratio
      end

      it_behaves_like :flash

      it_behaves_like :redirect
    end

    context "with 'work_package_done_ratio' using 'status'" do
      let(:message) { /Work package done ratios updated/ }

      before do
        allow(Setting).to receive(:work_package_done_ratio).and_return 'status'

        post :update_work_package_done_ratio
      end

      it_behaves_like :flash

      it_behaves_like :redirect
    end
  end
end
