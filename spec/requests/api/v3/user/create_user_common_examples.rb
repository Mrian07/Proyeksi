

shared_context 'represents the created user' do |expected_attributes|
  it 'returns the represented user' do
    send_request

    expect(last_response.status).to eq(201)
    expect(last_response.body).to have_json_type(Object).at_path('_links')
    expect(last_response.body)
      .to be_json_eql('User'.to_json)
            .at_path('_type')

    parameters.merge!(expected_attributes) if expected_attributes

    user = User.find_by!(login: parameters.fetch(:login, parameters[:email]))
    expect(user.firstname).to eq(parameters[:firstName])
    expect(user.lastname).to eq(parameters[:lastName])
    expect(user.mail).to eq(parameters[:email])
  end
end

shared_examples 'property is not writable' do |attributeName|
  it 'returns an error for the unwritable property' do
    send_request

    attr = JSON.parse(last_response.body).dig "_embedded", "details", "attribute"

    expect(last_response.status).to eq 422
    expect(attr).to eq attributeName
  end
end

shared_examples 'create user request flow' do
  let(:errors) { parse_json(last_response.body)['_embedded']['errors'] }

  describe 'empty request body' do
    let(:parameters) { {} }

    it 'returns an erroneous response' do
      send_request

      expect(last_response.status).to eq(422)

      expect(errors.count).to eq(5)
      expect(errors.collect { |el| el['_embedded']['details']['attribute'] })
        .to contain_exactly('password', 'login', 'firstName', 'lastName', 'email')

      expect(last_response.body)
        .to be_json_eql('urn:proyeksiapp-org:api:v3:errors:MultipleErrors'.to_json)
              .at_path('errorIdentifier')
    end
  end

  describe 'invited status' do
    let(:status) { 'invited' }
    let(:invitation_request) do
      {
        status: status,
        email: 'foo@example.org'
      }
    end

    describe 'invitation successful' do
      before do
        expect(ProyeksiApp::Notifications).to receive(:send) do |event, _|
          expect(event).to eq 'user_invited'
        end
      end

      context 'only mail set' do
        let(:parameters) { invitation_request }

        it_behaves_like 'represents the created user',
                        firstName: 'foo',
                        lastName: '@example.org'

        it 'sets the other attributes' do
          send_request

          user = User.find_by!(login: 'foo@example.org')
          expect(user.firstname).to eq('foo')
          expect(user.lastname).to eq('@example.org')
          expect(user.mail).to eq('foo@example.org')
        end
      end

      context 'mail and name set' do
        let(:parameters) { invitation_request.merge(firstName: 'First', lastName: 'Last') }

        it_behaves_like 'represents the created user'
      end
    end

    context 'missing email' do
      let(:parameters) { { status: status } }

      it 'marks the mail as missing' do
        send_request

        expect(last_response.body)
          .to be_json_eql('urn:proyeksiapp-org:api:v3:errors:MultipleErrors'.to_json)
                .at_path('errorIdentifier')

        expect(errors.count).to eq 4

        attributes = errors.map { |error| error.dig('_embedded', 'details', 'attribute') }
        expect(attributes).to contain_exactly('login', 'firstName', 'lastName', 'email')
      end
    end
  end

  describe 'invalid status' do
    let(:parameters) { { status: 'blablu' } }

    it 'returns an erroneous response' do
      send_request

      expect(last_response.status).to eq(422)

      expect(errors).not_to be_empty
      expect(last_response.body)
        .to be_json_eql('urn:proyeksiapp-org:api:v3:errors:MultipleErrors'.to_json)
              .at_path('errorIdentifier')

      expect(errors.collect { |el| el['message'] })
        .to include 'Status is not a valid status for new users.'
    end
  end
end
