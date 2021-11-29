

require 'spec_helper'

describe BacklogsSettingsController, type: :controller do
  current_user { FactoryBot.build_stubbed :admin }

  describe 'GET show' do
    it 'performs that request' do
      get :show
      expect(response).to be_successful
      expect(response).to render_template :show
    end

    context 'as regular user' do
      current_user { FactoryBot.build_stubbed :user }

      it 'fails' do
        get :show
        expect(response.status).to eq 403
      end
    end
  end

  describe 'PUT update' do
    subject do
      put :update,
          params: {
            settings: {
              task_type: task_type,
              story_types: story_types
            }
          }
    end

    context 'with invalid settings (Regression test #35157)' do
      let(:task_type) { '1234' }
      let(:story_types) { ['1234'] }

      it 'does not update the settings' do
        expect(Setting)
          .not_to(receive(:[]=))
          .with('plugin_openproject_backlogs')

        subject

        expect(response).to redirect_to action: :show
        expect(flash[:error]).to include I18n.t(:error_backlogs_task_cannot_be_story)
      end
    end

    context 'with valid settings' do
      let(:task_type) { '1234' }
      let(:story_types) { ['5555'] }

      it 'does update the settings' do
        expect(Setting)
          .to(receive(:[]=))
          .with('plugin_openproject_backlogs', { story_types: ['5555'], task_type: '1234' })

        subject

        expect(response).to redirect_to action: :show
        expect(flash[:notice]).to include I18n.t(:notice_successful_update)
        expect(flash[:error]).to be_nil
      end

      context 'with a non-admin' do
        current_user { FactoryBot.build_stubbed :user }

        it 'does not update the settings' do
          expect(Setting)
            .not_to(receive(:[]=))
            .with('plugin_openproject_backlogs')

          subject

          expect(response).not_to be_successful
          expect(response.status).to eq 403
        end
      end
    end
  end
end
