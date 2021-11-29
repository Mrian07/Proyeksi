

shared_examples 'represents the placeholder' do
  it do
    expect(last_response.status).to eq(200)
    expect(last_response.body)
      .to(be_json_eql('PlaceholderUser'.to_json).at_path('_type'))

    expect(last_response.body)
      .to(be_json_eql(placeholder.name.to_json).at_path('name'))

    expect(last_response.body)
      .to(be_json_eql(placeholder.id.to_json).at_path('id'))
  end
end
