#-- encoding: UTF-8



require 'spec_helper'

describe 'SettingSeeder' do
  subject { ::BasicData::SettingSeeder.new }

  let(:new_project_role) { Role.find_by(name: I18n.t(:default_role_project_admin)) }
  let(:closed_status) { Status.find_by(name: I18n.t(:default_status_closed)) }

  before do
    allow(STDOUT).to receive(:puts)
    allow(ActionMailer::Base).to receive(:perform_deliveries).and_return(false)
    allow(Delayed::Worker).to receive(:delay_jobs).and_return(false)

    expect { BasicDataSeeder.new.seed! }.not_to raise_error
  end

  def reseed!
    expect(subject).to receive(:update_unless_present).twice.and_call_original
    expect(subject).to be_applicable
    expect { subject.seed! }.not_to raise_error
  end

  shared_examples 'settings' do
    it 'applies initial settings' do
      Setting.where(name: %w(commit_fix_status_id new_project_user_role_id)).delete_all

      reseed!

      expect(Setting.commit_fix_status_id).to eq closed_status.id
      expect(Setting.new_project_user_role_id).to eq new_project_role.id
    end

    it 'does not override settings' do
      Setting.commit_fix_status_id = 1337
      Setting.where(name: 'new_project_user_role_id').delete_all

      reseed!

      expect(Setting.commit_fix_status_id).to eq 1337
      expect(Setting.new_project_user_role_id).to eq new_project_role.id
    end
  end
end
