

shared_examples 'updates the placeholder' do
  context 'with an empty name' do
    let(:parameters) do
      { name: '' }
    end

    it 'returns an error' do
      expect(last_response.status).to eq(422)
      expect(last_response.body)
        .to be_json_eql('urn:openproject-org:api:v3:errors:PropertyConstraintViolation'.to_json)
              .at_path('errorIdentifier')

      expect(parsed_response['_embedded']['details']['attribute'])
        .to eq 'name'

      expect(parsed_response['message'])
        .to eq "Name can't be blank."
    end
  end

  context 'with a new name' do
    let(:parameters) do
      { name: 'my new name' }
    end

    it 'updates the placeholder' do
      expect(last_response.status).to eq(200)

      placeholder.reload

      expect(placeholder.name).to eq 'my new name'
    end
  end
end
