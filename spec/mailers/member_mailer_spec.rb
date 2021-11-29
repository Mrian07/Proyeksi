#-- encoding: UTF-8



require 'spec_helper'

describe MemberMailer, type: :mailer do
  include OpenProject::ObjectLinking
  include ActionView::Helpers::UrlHelper
  include OpenProject::StaticRouting::UrlHelpers

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:member) do
    FactoryBot.build_stubbed(:member,
                             principal: principal,
                             project: project,
                             roles: roles)
  end
  let(:principal) { FactoryBot.build_stubbed(:user) }
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:roles) { [FactoryBot.build_stubbed(:role), FactoryBot.build_stubbed(:role)] }
  let(:message) { nil }

  around do |example|
    Timecop.freeze(Time.current) do
      example.run
    end
  end

  shared_examples_for 'has a subject' do |key|
    it "has a subject" do
      if project
        expect(subject.subject)
          .to eql I18n.t(key, project: project.name)
      else
        expect(subject.subject)
          .to eql I18n.t(key)
      end
    end
  end

  shared_examples_for 'fails for a group' do
    let(:principal) { FactoryBot.build_stubbed(:group) }

    it 'raises an argument error' do
      # Calling .to in order to have the mail rendered
      expect { subject.to }
        .to raise_error ArgumentError
    end
  end

  shared_examples_for "sends a mail to the member's principal" do
    let(:principal) { FactoryBot.build_stubbed(:group) }

    it 'raises an argument error' do
      # Calling .to in order to have the mail rendered
      expect { subject.to }
        .to raise_error ArgumentError
    end
  end

  shared_examples_for 'sets the expected message_id header' do
    it 'sets the expected message_id header' do
      expect(subject['Message-ID'].value)
        .to eql "<op.member-#{member.id}.#{Time.current.strftime('%Y%m%d%H%M%S')}.#{current_user.id}@example.net>"
    end
  end

  shared_examples_for 'sets the expected openproject header' do
    it 'sets the expected openproject header' do
      expect(subject['X-OpenProject-Project'].value)
        .to eql project.identifier
    end
  end

  shared_examples_for 'has the expected body' do
    let(:body) { subject.body.parts.detect { |part| part['Content-Type'].value == 'text/html' }.body.to_s }


    it 'highlights the roles received' do
      expected = <<~MSG
        <ul>
          <li> #{roles.first.name} </li>
          <li> #{roles.last.name} </li>
        </ul>
      MSG

      expect(body)
        .to be_html_eql(expected)
        .at_path('body/table/tr/td/ul')
    end

    context 'with a custom message' do
      let(:message) { "Some **styled** message" }

      it 'has the expected header' do
        params = {
          project: project ? link_to_project(project, only_path: false) : nil,
          user: link_to_user(current_user, only_path: false)
        }.compact

        expect(body)
          .to include(I18n.t(:"#{expected_header}.with_message", **params))
      end

      it 'includes the custom message' do
        expect(body)
          .to include("Some <strong>styled</strong> message")
      end
    end

    context 'without a custom message' do

      it 'has the expected header' do
        params = {
          project: project ? link_to_project(project, only_path: false) : nil,
          user: link_to_user(current_user, only_path: false)
        }.compact

        expect(body)
          .to include(I18n.t(:"#{expected_header}.without_message", **params))
      end
    end
  end

  describe '#added_project' do
    subject { MemberMailer.added_project(current_user, member, message) }

    it_behaves_like "sends a mail to the member's principal"
    it_behaves_like 'has a subject', :'mail_member_added_project.subject'
    it_behaves_like 'sets the expected message_id header'
    it_behaves_like 'sets the expected openproject header'
    it_behaves_like 'has the expected body' do
      let(:expected_header) do
        "mail_member_added_project.body.added_by"
      end
    end
    it_behaves_like 'fails for a group'
  end

  describe '#updated_project' do
    subject { MemberMailer.updated_project(current_user, member, message) }

    it_behaves_like "sends a mail to the member's principal"
    it_behaves_like 'has a subject', :'mail_member_updated_project.subject'
    it_behaves_like 'sets the expected message_id header'
    it_behaves_like 'sets the expected openproject header'
    it_behaves_like 'has the expected body' do
      let(:expected_header) do
        "mail_member_updated_project.body.updated_by"
      end
    end
    it_behaves_like 'fails for a group'
  end

  describe '#updated_global' do
    let(:project) { nil }

    subject { MemberMailer.updated_global(current_user, member, message) }

    it_behaves_like "sends a mail to the member's principal"
    it_behaves_like 'has a subject', :'mail_member_updated_global.subject'
    it_behaves_like 'sets the expected message_id header'
    it_behaves_like 'has the expected body' do
      let(:expected_header) do
        "mail_member_updated_global.body.updated_by"
      end
    end
    it_behaves_like 'fails for a group'
  end
end
