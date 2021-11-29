

require File.dirname(__FILE__) + '/../spec_helper'

describe MeetingsController, type: :controller do
  let(:project) { FactoryBot.create :project }

  before do
    allow(Project).to receive(:find).and_return(project)

    allow(@controller).to receive(:authorize)
    allow(@controller).to receive(:check_if_login_required)
  end

  describe 'GET' do
    describe 'index' do
      before(:each) do
        @ms = [FactoryBot.build_stubbed(:meeting),
               FactoryBot.build_stubbed(:meeting),
               FactoryBot.build_stubbed(:meeting)]
        allow(@ms).to receive(:from_tomorrow).and_return(@ms)

        allow(project).to receive(:meetings).and_return(@ms)
        %i[with_users_by_date page per_page].each do |meth|
          expect(@ms).to receive(meth).and_return(@ms)
        end
        @grouped = double('grouped')
        expect(Meeting).to receive(:group_by_time).with(@ms).and_return(@grouped)
      end
      describe 'html' do
        before(:each) do
          get 'index', params: { project_id: project.id }
        end
        it { expect(response).to be_successful }
        it { expect(assigns(:meetings_by_start_year_month_date)).to eql @grouped }
      end
    end

    describe 'show' do
      before(:each) do
        @m = FactoryBot.build_stubbed(:meeting, project: project, agenda: nil)
        allow(Meeting).to receive_message_chain(:includes, :find).and_return(@m)
      end
      describe 'html' do
        before(:each) do
          get 'show', params: { id: @m.id }
        end
        it { expect(response).to be_successful }
      end
    end

    describe 'new' do
      before(:each) do
        allow(Project).to receive(:find).and_return(project)
        @m = FactoryBot.build_stubbed(:meeting)
        allow(Meeting).to receive(:new).and_return(@m)
      end
      describe 'html' do
        before(:each) do
          get 'new',  params: { project_id: project.id }
        end
        it { expect(response).to be_successful }
        it { expect(assigns(:meeting)).to eql @m }
      end
    end

    describe 'edit' do
      before(:each) do
        @m = FactoryBot.build_stubbed(:meeting, project: project)
        allow(Meeting).to receive_message_chain(:includes, :find).and_return(@m)
      end
      describe 'html' do
        before(:each) do
          get 'edit', params: { id: @m.id }
        end
        it { expect(response).to be_successful }
        it { expect(assigns(:meeting)).to eql @m }
      end
    end

    describe 'create' do
      render_views

      before do
        allow(Project).to receive(:find).and_return(project)
        post :create,
             params: {
               project_id: project.id,
               meeting: {
                 title: 'Foobar',
                 duration: '1.0'
               }.merge(params)
             }
      end

      describe 'invalid start_date' do
        let(:params) do
          {
            start_date: '-',
            start_time_hour: '10:00'
          }
        end

        it 'renders an error' do
          expect(response.status).to eql 200
          expect(response).to render_template :new
          expect(response.body)
            .to have_selector '#errorExplanation li',
                              text: "Start date " +
                                    I18n.t('activerecord.errors.messages.not_an_iso_date')
        end
      end

      describe 'invalid start_time_hour' do
        let(:params) do
          {
            start_date: '2015-06-01',
            start_time_hour: '-'
          }
        end

        it 'renders an error' do
          expect(response.status).to eql 200
          expect(response).to render_template :new
          expect(response.body)
            .to have_selector '#errorExplanation li',
                              text: "Starting time " +
                                    I18n.t('activerecord.errors.messages.invalid_time_format')
        end
      end
    end
  end
end
