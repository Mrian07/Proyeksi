

require 'spec_helper'

shared_examples_for 'has ISO 8601 date only' do
  it 'exists' do
    is_expected.to have_json_path(json_path)
  end

  it 'indicates date only as ISO 8601' do
    called_with_expected = false
    expect(::API::V3::Utilities::DateTimeFormatter).to receive(:format_date) do |actual, *_|
      called_with_expected = true if actual.eql? date
    end.at_least(:once)

    subject # we need to resolve the subject for calls to occur
    expect(called_with_expected).to be_truthy
  end
end

shared_examples_for 'has UTC ISO 8601 date and time' do
  it 'exists' do
    is_expected.to have_json_path(json_path)
  end

  it 'indicates date and time as ISO 8601' do
    called_with_expected = false
    expect(::API::V3::Utilities::DateTimeFormatter).to receive(:format_datetime) do |actual, *_|
      # ActiveSupport flaws :eql? we circumvent that by calling utc (which is equally valid)
      called_with_expected = true if actual.utc.eql? date.utc
    end.at_least(:once)

    subject # we need to resolve the subject for calls to occur
    expect(called_with_expected).to be_truthy
  end
end
