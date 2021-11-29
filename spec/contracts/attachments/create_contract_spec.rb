#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe Attachments::CreateContract do
  include_context 'ModelContract shared context'

  let(:current_user) { FactoryBot.build_stubbed :user }
  let(:model) do
    FactoryBot.build :attachment,
                     container: container,
                     content_type: content_type,
                     file: file,
                     filename: filename,
                     author: current_user
  end
  let(:contract) { described_class.new model, user, options: contract_options }
  let(:contract_options) { {} }

  let(:user) { current_user }
  let(:container) { nil }
  let(:file) do
    Rack::Test::UploadedFile.new(
      Rails.root.join("spec/fixtures/files/image.png"),
      'image/png',
      true
    )
  end
  let(:content_type) { 'image/png' }
  let(:filename) { 'image.png' }

  let(:can_attach_global) { true }

  before do
    allow(Redmine::Acts::Attachable.attachables)
      .to receive(:none?).and_return(!can_attach_global)
  end

  context 'with user who has no permissions' do
    let(:can_attach_global) { false }

    it_behaves_like 'contract is invalid', base: :error_unauthorized
  end

  context 'with a user that is not the author' do
    let(:user) { FactoryBot.build_stubbed :user }

    it_behaves_like 'contract is invalid', author: :invalid
  end

  context 'with user who has permissions to add' do
    it_behaves_like 'contract is valid'
  end

  context 'with a container' do
    let(:container) { FactoryBot.build_stubbed :work_package }

    before do
      allow(container)
        .to receive(:attachments_addable?)
              .with(user)
              .and_return(can_attach)
    end

    context 'with user who has no permissions' do
      let(:can_attach) { false }

      it_behaves_like 'contract is invalid', base: :error_unauthorized
    end

    context 'with user who has permissions to add' do
      let(:can_attach) { true }

      it_behaves_like 'contract is valid'
    end

  end

  context 'with an empty whitelist',
          with_settings: { attachment_whitelist: %w[] } do
    it_behaves_like 'contract is valid'
  end

  context 'with a matching mime whitelist',
          with_settings: { attachment_whitelist: %w[image/png] } do
    it_behaves_like 'contract is valid'
  end

  context 'with a matching extension whitelist',
          with_settings: { attachment_whitelist: %w[*.png] } do
    it_behaves_like 'contract is valid'
  end

  context 'with a non-matching whitelist',
          with_settings: { attachment_whitelist: %w[*.jpg image/jpeg] } do
    it_behaves_like 'contract is invalid', content_type: :not_whitelisted

    context 'when disabling the whitelist check' do
      let(:contract_options) do
        { whitelist: [] }
      end

      it_behaves_like 'contract is valid'
    end

    context 'when overriding the whitelist' do
      let(:contract_options) do
        { whitelist: %w[*.png] }
      end

      it_behaves_like 'contract is valid'
    end
  end
end
