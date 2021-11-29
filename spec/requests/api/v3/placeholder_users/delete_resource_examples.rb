

shared_examples 'deletion allowed' do
  it 'should respond with 202' do
    expect(last_response.status).to eq 202
  end

  it 'should lock the account and mark for deletion' do
    expect(Principals::DeleteJob)
      .to have_been_enqueued
            .with(placeholder)

    expect(placeholder.reload).to be_locked
  end

  context 'with a non-existent user' do
    let(:path) { api_v3_paths.placeholder_user 1337 }

    it_behaves_like 'not found'
  end
end

shared_examples 'deletion is not allowed' do
  it 'should respond with 403' do
    expect(last_response.status).to eq 403
  end

  it 'should not delete the user' do
    expect(PlaceholderUser.exists?(placeholder.id)).to be_truthy
  end
end
