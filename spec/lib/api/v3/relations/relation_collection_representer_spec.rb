

require 'spec_helper'

describe ::API::V3::Relations::RelationCollectionRepresenter do
  let(:work_package) do
    FactoryBot.build_stubbed(:work_package)
  end

  let(:relations) do
    (1..3).map do
      FactoryBot.build_stubbed(:relation,
                               from: work_package,
                               to: FactoryBot.build_stubbed(:work_package))
    end
  end

  let(:user) do
    FactoryBot.build_stubbed(:user)
  end

  def self_link
    'a link that is provided'
  end

  let(:representer) do
    described_class.new(relations,
                        self_link: self_link,
                        current_user: user)
  end

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'unpaginated APIv3 collection',
                    3,
                    'a link that is provided',
                    'Relation'
  end
end
