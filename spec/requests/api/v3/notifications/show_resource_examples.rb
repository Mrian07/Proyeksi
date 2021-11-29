

shared_examples 'represents the notification' do
  it 'represents the notification', :aggregate_failures do
    expect(last_response.status).to eq(200)
    expect(last_response.body)
      .to(be_json_eql('Notification'.to_json).at_path('_type'))

    expect(last_response.body)
      .to(be_json_eql(notification.subject.to_json).at_path('subject'))

    expect(last_response.body)
      .to(be_json_eql(notification.read_ian.to_json).at_path('readIAN'))

    expect(last_response.body)
      .to(be_json_eql(::API::V3::Utilities::DateTimeFormatter.format_datetime(notification.created_at).to_json).at_path('createdAt'))

    expect(last_response.body)
      .to(be_json_eql(::API::V3::Utilities::DateTimeFormatter.format_datetime(notification.updated_at).to_json).at_path('updatedAt'))

    expect(last_response.body)
      .to(be_json_eql(notification.id.to_json).at_path('id'))
  end
end
