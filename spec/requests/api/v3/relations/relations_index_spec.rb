

require 'spec_helper'

describe 'GET /api/v3/relations', type: :request do
  let(:user) { FactoryBot.create :admin }

  let(:work_package) { FactoryBot.create :work_package }
  let(:other_work_package) { FactoryBot.create :work_package }

  let!(:relations) do
    def new_relation(opts = {})
      relation_type = opts.delete(:type)

      relation = FactoryBot.create :relation, opts.merge(relation_type: relation_type)
      relation.id
    end

    def new_work_package
      FactoryBot.create :work_package
    end

    [
      new_relation(from: work_package, to: other_work_package, type: 'follows'),
      new_relation(from: work_package, to: new_work_package, type: 'blocks'),
      new_relation(from: new_work_package, to: work_package, type: 'follows'),
      new_relation(from: new_work_package, to: new_work_package, type: 'blocks')
    ]
  end

  before do
    login_as user
  end

  describe "filters" do
    def filter_relations(name, operator, values)
      filter = {
        name => {
          "operator" => operator,
          "values" => values
        }
      }
      params = {
        filters: [filter].to_json
      }

      header "Content-Type", "application/json"
      get "/api/v3/relations", params

      json = JSON.parse last_response.body

      Array(Hash(json).dig("_embedded", "elements")).map { |e| e["id"] }
    end

    ##
    # We're testing all cases within one example to save a lot of time.
    # Initializing the relations takes very long (about 2s) and it's unnecessary
    # to repeat that step for every example as we are not mutating anything.
    # This saves about 75% on the runtime (6s vs 24s on this machine) of the spec.
    it 'work' do
      expect(filter_relations("id", "=", [relations[0], relations[2]]))
        .to match_array [relations[0], relations[2]]
      expect(filter_relations("id", "!", [relations[0], relations[2]]))
        .to match_array [relations[1], relations[3]]

      expect(filter_relations("from", "=", [work_package.id]))
        .to match_array [relations[0], relations[1]]
      expect(filter_relations("from", "!", [work_package.id]))
        .to match_array [relations[2], relations[3]]

      expect(filter_relations("to", "=", [work_package.id]))
        .to eq [relations[2]]
      expect(filter_relations("to", "!", [work_package.id]))
        .to match_array [relations[0], relations[1], relations[3]]

      expect(filter_relations("involved", "=", [work_package.id]))
        .to match_array [relations[0], relations[1], relations[2]]
      expect(filter_relations("involved", "!", [work_package.id]))
        .to eq [relations[3]]

      expect(filter_relations("type", "=", ["blocks"]))
        .to match_array [relations[1], relations[3]]
      expect(filter_relations("type", "=", ["blocks", "precedes"]))
        .to match_array [relations[0], relations[1], relations[2], relations[3]]
      expect(filter_relations("type", "!", ["blocks"]))
        .to match_array [relations[0], relations[2]]
    end
  end
end
