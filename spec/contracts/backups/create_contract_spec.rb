#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe Backups::CreateContract do
  let(:backup) { Backup.new }
  let(:contract) { described_class.new backup, current_user, options: { backup_token: backup_token.plain_value } }
  let(:backup_token) { FactoryBot.create :backup_token, user: current_user }

  include_context 'ModelContract shared context'

  it_behaves_like 'contract is valid for active admins and invalid for regular users'

  context 'with regular user who has the :create_backup permission' do
    let(:current_user) { FactoryBot.create :user, global_permissions: [:create_backup] }

    it_behaves_like 'contract is valid'
  end
end
