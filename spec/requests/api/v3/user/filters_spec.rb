

require 'spec_helper'

describe 'GET /api/v3/users', type: :request do
  let!(:users) do
    [
      FactoryBot.create(:admin, login: 'admin', status: :active),
      FactoryBot.create(:user, login: 'h.wurst', status: :active),
      FactoryBot.create(:user, login: 'h.heine', status: :locked),
      FactoryBot.create(:user, login: 'm.mario', status: :active)
    ]
  end

  before do
    login_as users.first
  end

  def filter_users(name, operator, values)
    filter = {
      name => {
        "operator" => operator,
        "values" => Array(values)
      }
    }
    params = {
      filters: [filter].to_json
    }

    get "/api/v3/users", params

    json = JSON.parse last_response.body

    Array(Hash(json).dig("_embedded", "elements")).map { |e| e["login"] }
  end

  describe 'status filter' do
    it '=' do
      expect(filter_users("status", "=", :active)).to match_array ["admin", "h.wurst", "m.mario"]
    end

    it '!' do
      expect(filter_users("status", "!", :active)).to match_array ["h.heine"]
    end
  end

  describe 'login filter' do
    it '=' do
      expect(filter_users("login", "=", "admin")).to match_array ["admin"]
    end

    it '!' do
      expect(filter_users("login", "!", "admin")).to match_array ["h.wurst", "h.heine", "m.mario"]
    end

    it '~' do
      expect(filter_users("login", "~", "h.")).to match_array ["h.wurst", "h.heine"]
    end

    it '!~' do
      expect(filter_users("login", "!~", "h.")).to match_array ["admin", "m.mario"]
    end
  end
end
