

require 'spec_helper'

shared_examples_for 'API V3 collection response' do |total, count, element_type, collection_type = 'Collection'|
  subject { last_response.body }
  # If an array of elements is provided, those elements are expected
  # to be embedded in the _embedded/elements section in the order provided.
  # Only the id of the element is checked for.
  let(:elements) { nil }

  # Allow input to pass a proc to avoid counting before the example
  # context
  let(:total_number) do
    if total.is_a? Proc
      total.call
    else
      total
    end
  end

  let(:count_number) do
    if count.is_a? Proc
      count.call
    else
      count
    end
  end

  it 'returns a collection successfully' do
    aggregate_failures do
      expect(last_response.status).to eql(200)
      expect(subject).to be_json_eql(collection_type.to_json).at_path('_type')
      expect(subject).to be_json_eql(count_number.to_json).at_path('count')
      expect(subject).to be_json_eql(total_number.to_json).at_path('total')
      expect(subject).to have_json_size(count_number).at_path('_embedded/elements')

      if element_type && count_number > 0
        expect(subject).to be_json_eql(element_type.to_json).at_path('_embedded/elements/0/_type')
      end

      elements&.each_with_index do |element, index|
        expect(subject).to be_json_eql(element.id.to_json).at_path("_embedded/elements/#{index}/id")
      end
    end
  end
end
