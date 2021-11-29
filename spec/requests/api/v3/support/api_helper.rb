

shared_examples_for 'safeguarded API' do
  it { expect(last_response.status).to eq(404) }
end

shared_examples_for 'valid activity request' do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:status_code) { 200 }

  before do
    allow(User).to receive(:current).and_return(admin)
  end

  it { expect(last_response.status).to eq(status_code) }

  describe 'response body' do
    subject { last_response.body }

    it { is_expected.to be_json_eql('Activity::Comment'.to_json).at_path('_type') }

    it { is_expected.to be_json_eql(comment.to_json).at_path('comment/raw') }
  end
end

shared_examples_for 'invalid activity request' do
  shared_let(:admin) { FactoryBot.create :admin }

  before do
    allow(User).to receive(:current).and_return(admin)
  end

  it { expect(last_response.status).to eq(422) }
end
