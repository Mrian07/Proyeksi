

require 'spec_helper'

describe WorkPackages::CalendarsController, type: :controller do
  let(:project) do
    FactoryBot.build_stubbed(:project).tap do |p|
      allow(Project)
        .to receive(:find)
        .with(p.id.to_s)
        .and_return(p)
    end
  end
  let(:permissions) { [:view_calendar] }
  let(:user) do
    FactoryBot.build_stubbed(:user).tap do |user|
      allow(user)
        .to receive(:allowed_to?) do |permission, p, global:|
        permission[:controller] == 'work_packages/calendars' &&
          permission[:action] == 'index' &&
          (p.nil? || p == project)
      end
    end
  end

  before { login_as(user) }

  describe '#index' do
    shared_examples_for 'calendar#index' do
      subject { response }

      it { is_expected.to be_successful }

      it { is_expected.to render_template('work_packages/calendars/index') }
    end

    context 'cross-project' do
      before do
        get :index
      end

      it_behaves_like 'calendar#index'
    end

    context 'project' do
      before do
        get :index, params: { project_id: project.id }
      end

      it_behaves_like 'calendar#index'
    end
  end
end
