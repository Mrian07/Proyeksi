

require 'spec_helper'

describe Type, type: :model do
  let(:type) { FactoryBot.create :type, name: "Issue" }

  it 'bcf_thumbnail is available as a WorkPackageRepresenter attribute' do
    expect(API::V3::WorkPackages::Schema::WorkPackageSchemaRepresenter.representable_attrs.keys).to(
      include('bcf_thumbnail')
    )
  end

  it 'bcf_thumbnail is not within the attributes of the default form configuration' do
    expect(type.attribute_groups.map(&:attributes).flatten).not_to include('bcf_thumbnail')
  end
end
