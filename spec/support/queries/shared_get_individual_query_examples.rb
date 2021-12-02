

shared_examples_for 'GET individual query' do
  let(:work_package) { FactoryBot.create(:work_package, project: project) }
  let(:filter) { [] }
  let(:path) do
    if filter.any?
      params = CGI.escape(JSON.dump(filter))
      "#{base_path}?filters=#{params}"
    else
      base_path
    end
  end

  before do
    work_package
    get path
  end

  it 'should succeed' do
    expect(last_response.status).to eq(200)
  end

  it 'has the right endpoint set for the self reference' do
    expect(last_response.body)
      .to be_json_eql(path.to_json)
      .at_path('_links/self/href')
  end

  it 'embedds the query results' do
    expect(last_response.body)
      .to be_json_eql('WorkPackageCollection'.to_json)
      .at_path('_embedded/results/_type')
    expect(last_response.body)
      .to be_json_eql(api_v3_paths.work_package(work_package.id).to_json)
      .at_path('_embedded/results/_embedded/elements/0/_links/self/href')
  end

  context 'when providing a valid filters' do
    let(:filter) do
      [
        {
          "status": {
            "operator": "c",
            "values": []
          }
        }
      ]
    end

    it 'uses the provided filter' do
      expect(last_response.body)
        .to be_json_eql(0.to_json)
        .at_path('_embedded/results/total')
    end
  end

  context 'when providing an invalid filter' do
    let(:filter) do
      [
        {
          "some": "bogus"
        }
      ]
    end

    it 'returns an error' do
      expect(last_response.body)
        .to be_json_eql("urn:proyeksiapp-org:api:v3:errors:InvalidQuery".to_json)
        .at_path('errorIdentifier')
    end
  end
end
