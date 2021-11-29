

require 'spec_helper'

describe ::API::V3::HelpTexts::HelpTextCollectionRepresenter do
  let!(:help_texts) do
    [
      FactoryBot.build_stubbed(:work_package_help_text, attribute_name: 'id'),
      FactoryBot.build_stubbed(:work_package_help_text, attribute_name: 'status')
    ]
  end

  let(:user) { FactoryBot.build_stubbed(:user) }

  def self_link
    'a link that is provided'
  end

  let(:representer) do
    described_class.new(help_texts,
                        self_link: self_link,
                        current_user: user)
  end

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'unpaginated APIv3 collection',
                    2,
                    'a link that is provided',
                    'HelpText'
  end
end
