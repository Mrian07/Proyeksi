

shared_examples_for 'property' do |name|
  it "has the #{name} property" do
    is_expected
      .to be_json_eql(value.to_json)
      .at_path(name.to_s)
  end
end

shared_examples_for 'formattable property' do |name|
  it "has the #{name} property" do
    is_expected
      .to be_json_eql(value.to_json)
      .at_path("#{name}/raw")
  end
end

shared_examples_for 'date property' do |name|
  it_behaves_like 'has ISO 8601 date only' do
    let(:json_path) { name.to_s }
    let(:date) { value }
  end
end

shared_examples_for 'datetime property' do |name|
  it_behaves_like 'has UTC ISO 8601 date and time' do
    let(:json_path) { name.to_s }
    let(:date) { value }
  end
end
