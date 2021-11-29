

require 'spec_helper'

describe ::API::V3::Relations::RelationRepresenter do
  let(:user) { FactoryBot.build_stubbed(:admin) }

  let(:from) { FactoryBot.build_stubbed(:stubbed_work_package) }
  let(:to) { FactoryBot.build_stubbed :stubbed_work_package }

  let(:type) { "follows" }
  let(:description) { "This first" }
  let(:delay) { 3 }

  let(:relation) do
    FactoryBot.build_stubbed :relation,
                             from: from,
                             to: to,
                             relation_type: type,
                             description: description,
                             delay: delay
  end

  let(:representer) { described_class.new relation, current_user: user }

  let(:result) do
    {
      "_type" => "Relation",
      "_links" => {
        "self" => {
          "href" => "/api/v3/relations/#{relation.id}"
        },
        "updateImmediately" => {
          "href" => "/api/v3/relations/#{relation.id}",
          "method" => "patch"
        },
        "delete" => {
          "href" => "/api/v3/relations/#{relation.id}",
          "method" => "delete",
          "title" => "Remove relation"
        },
        "from" => {
          "href" => "/api/v3/work_packages/#{from.id}",
          "title" => from.subject
        },
        "to" => {
          "href" => "/api/v3/work_packages/#{to.id}",
          "title" => to.subject
        }
      },
      "id" => relation.id,
      "name" => "follows",
      "type" => "follows",
      "reverseType" => "precedes",
      "description" => description,
      "delay" => delay
    }
  end

  it 'serializes the relation correctly' do
    data = JSON.parse representer.to_json

    expect(data).to eq result
  end

  it 'deserializes the relation correctly' do
    rep = ::API::V3::Relations::RelationRepresenter.new OpenStruct.new, current_user: user
    rel = rep.from_json result.except(:id).to_json

    expect(rel.from_id).to eq from.id.to_s
    expect(rel.to_id).to eq to.id.to_s
    expect(rel.delay).to eq delay
    expect(rel.relation_type).to eq type
    expect(rel.description).to eq description
    expect(rel.delay).to eq delay
  end
end
