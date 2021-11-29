

require 'spec_helper'

describe MeetingContentsController do
  shared_let(:role) { FactoryBot.create(:role, permissions: [:view_meetings]) }
  shared_let(:project) { FactoryBot.create(:project) }
  shared_let(:author) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }
  shared_let(:watcher1) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }
  shared_let(:watcher2) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }
  shared_let(:meeting) do
    User.execute_as author do
      FactoryBot.create(:meeting, author: author, project: project)
    end
  end
  shared_let(:meeting_agenda) do
    User.execute_as author do
      FactoryBot.create(:meeting_agenda, meeting: meeting)
    end
  end

  before(:each) do
    ActionMailer::Base.deliveries = []
    allow_any_instance_of(MeetingContentsController).to receive(:find_content)
    allow(controller).to receive(:authorize)
    meeting.participants.merge([meeting.participants.build(user: watcher1, invited: true, attended: false),
                                meeting.participants.build(user: watcher2, invited: true, attended: false)])
    meeting.save!
    controller.instance_variable_set(:@content, meeting_agenda.meeting.agenda)
    controller.instance_variable_set(:@content_type, 'meeting_agenda')
  end

  shared_examples_for 'delivered by mail' do
    before { put action, params: { meeting_id: meeting.id } }

    it { expect(ActionMailer::Base.deliveries.count).to eql(mail_count) }
  end

  describe 'PUT' do
    describe 'notify' do
      let(:action) { 'notify' }

      before do
        author.save!
      end

      it_behaves_like 'delivered by mail' do
        let(:mail_count) { 2 }
      end

      context 'with an error during deliver' do
        before do
          allow(MeetingMailer).to receive(:content_for_review).and_raise(Net::SMTPError)
        end

        it 'does not raise an error' do
          expect { put 'notify', params: { meeting_id: meeting.id } }.to_not raise_error
        end

        it 'produces a flash message containing the mail addresses raising the error' do
          put 'notify',  params: { meeting_id: meeting.id }
          meeting.participants.each do |participant|
            expect(flash[:error]).to include(participant.name)
          end
        end
      end
    end

    describe 'icalendar' do
      let(:action) { 'icalendar' }

      before do
        author.save!
      end

      it_behaves_like 'delivered by mail' do
        let(:mail_count) { 3 }
      end

      context 'with an error during deliver' do
        before do
          author.save!
          allow(MeetingMailer).to receive(:content_for_review).and_raise(Net::SMTPError)
        end

        it 'does not raise an error' do
          expect { put 'notify', params: { meeting_id: meeting.id } }.to_not raise_error
        end

        it 'produces a flash message containing the mail addresses raising the error' do
          put 'notify',  params: { meeting_id: meeting.id }
          meeting.participants.each do |participant|
            expect(flash[:error]).to include(participant.name)
          end
        end
      end
    end
  end
end
