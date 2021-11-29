

shared_context 'create placeholder user request context' do
  include API::V3::Utilities::PathHelper

  let(:parameters) do
    { name: 'PLACEHOLDER' }
  end

  let(:send_request) do
    header "Content-Type", "application/json"
    post api_v3_paths.placeholder_users, parameters.to_json
  end

  let(:parsed_response) { JSON.parse(last_response.body) }
end

shared_examples 'create placeholder user request flow' do
  include_context 'create placeholder user request context'

  describe 'with EE', with_ee: %i[placeholder_users] do
    describe 'empty request body' do
      let(:parameters) { {} }

      it 'returns an erroneous response' do
        send_request

        expect(last_response.status).to eq(422)
        expect(last_response.body)
          .to be_json_eql('urn:openproject-org:api:v3:errors:PropertyConstraintViolation'.to_json)
                .at_path('errorIdentifier')

        expect(parsed_response['_embedded']['details']['attribute'])
          .to eq 'name'
      end
    end

    it 'creates the placeholder when valid' do
      send_request

      expect(last_response.status).to eq(201)
      placeholder = PlaceholderUser.find_by(name: parameters[:name])
      expect(placeholder).to be_present
    end

    describe 'when the user name already exists' do
      let!(:placeholder) { FactoryBot.create :placeholder_user, name: 'PLACEHOLDER' }

      it 'returns an error' do
        send_request

        expect(last_response.status).to eq(422)
        expect(last_response.body)
          .to be_json_eql('urn:openproject-org:api:v3:errors:PropertyConstraintViolation'.to_json)
                .at_path('errorIdentifier')

        expect(parsed_response['_embedded']['details']['attribute'])
          .to eq 'name'

        expect(parsed_response['message'])
          .to eq 'Name has already been taken.'
      end
    end
  end

  describe 'without ee' do
    it 'adds an error that its only available in EE' do
      send_request

      expect(last_response.status).to eq(422)
      expect(parsed_response['message'])
        .to eq('is only available in the OpenProject Enterprise Edition')

      expect(last_response.body)
        .to be_json_eql('urn:openproject-org:api:v3:errors:PropertyConstraintViolation'.to_json)
              .at_path('errorIdentifier')
    end
  end
end
