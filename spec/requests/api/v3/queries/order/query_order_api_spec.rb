

require 'spec_helper'
require 'rack/test'

describe "/api/v3/queries/:id/order", type: :request do
  let(:user) { FactoryBot.create :admin }
  let(:query) { FactoryBot.create(:query, name: "A Query", user: user) }
  let(:path) { "/api/v3/queries/#{query.id}/order" }

  subject(:body) { JSON.parse(last_response.body) }

  before do
    login_as user
    header "Content-Type", "application/json"
  end

  describe 'with order present' do
    let(:wp1) { FactoryBot.create :work_package }
    let(:wp2) { FactoryBot.create :work_package }

    before do
      query.ordered_work_packages.create(work_package_id: wp1.id, position: 0)
      query.ordered_work_packages.create(work_package_id: wp2.id, position: 8192)
    end

    it 'returns the order' do
      get path

      expect(last_response.status).to eq 200
      expect(body).to be_a Hash
      expect(body).to eq({ wp1.id => 0, wp2.id => 8192 }.stringify_keys)
    end
  end

  describe '#patch' do
    let!(:wp1) { FactoryBot.create :work_package }
    let!(:wp2) { FactoryBot.create :work_package }

    let(:timestamp) { ::API::V3::Utilities::DateTimeFormatter.format_datetime(query.updated_at) }

    before do
      query.ordered_work_packages.create(work_package_id: wp1.id, position: 0)
    end

    it 'allows inserting a delta' do
      patch path, { delta: { wp2.id.to_s => 1234 } }.to_json
      expect(last_response.status).to eq 200

      query.reload
      expect(body).to eq('t' => timestamp)
      expect(query.ordered_work_packages.find_by(work_package: wp2).position).to eq 1234
    end

    it 'allows removing an item' do
      patch path, { delta: { wp1.id.to_s => -1 } }.to_json
      expect(last_response.status).to eq 200

      query.reload
      expect(body).to eq('t' => timestamp)
      expect(query.ordered_work_packages.to_a).to be_empty
    end
  end
end
