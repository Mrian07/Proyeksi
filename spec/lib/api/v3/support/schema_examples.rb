

require 'spec_helper'

shared_examples_for 'has basic schema properties' do
  it 'exists' do
    is_expected.to have_json_path(path)
  end

  it 'has a type' do
    is_expected.to be_json_eql(type.to_json).at_path("#{path}/type")
  end

  it 'has a name' do
    is_expected.to be_json_eql(name.to_json).at_path("#{path}/name")
  end

  it 'indicates if it is required' do
    is_expected.to be_json_eql(required.to_json).at_path("#{path}/required")
  end

  it 'indicates if it is writable' do
    is_expected.to be_json_eql(writable.to_json).at_path("#{path}/writable")
  end

  it 'indicates if it has default' do
    expected_has_default = if defined?(has_default)
                             has_default
                           else
                             false
                           end

    is_expected
      .to be_json_eql(expected_has_default.to_json)
      .at_path("#{path}/hasDefault")
  end

  it 'indicates if it has a location' do
    if defined?(location)
      is_expected
        .to be_json_eql(location.to_json)
              .at_path("#{path}/location")
    else
      is_expected.not_to have_json_path("#{path}/location")
    end
  end

  it 'indicates if it has a description' do
    if defined?(description)
      is_expected
        .to be_json_eql(description.to_json)
              .at_path("#{path}/description/raw")
    else
      is_expected.not_to have_json_path("#{path}/description")
    end
  end
end

shared_examples_for 'indicates length requirements' do
  it 'indicates its minimum length' do
    if defined?(min_length)
      is_expected
        .to be_json_eql(min_length.to_json)
        .at_path("#{path}/minLength")
    else
      is_expected
        .not_to have_json_path("#{path}/minLength")
    end
  end

  it 'indicates its maximum length' do
    if defined?(max_length)
      is_expected
        .to be_json_eql(max_length.to_json)
        .at_path("#{path}/maxLength")
    else
      is_expected
        .not_to have_json_path("#{path}/maxLength")
    end
  end
end

shared_examples_for 'links to allowed values directly' do
  it 'has the expected number of links' do
    is_expected.to have_json_size(hrefs.size).at_path("#{path}/_links/allowedValues")
  end

  it 'contains links to the allowed values' do
    index = 0
    hrefs.each do |href|
      href_path = "#{path}/_links/allowedValues/#{index}/href"
      is_expected.to be_json_eql(href.to_json).at_path(href_path)
      index += 1
    end
  end
end

shared_examples_for 'links to and embeds allowed values directly' do
  it_behaves_like 'links to allowed values directly'

  it 'has the expected number of embedded values' do
    is_expected.to have_json_size(hrefs.size).at_path("#{path}/_embedded/allowedValues")
  end

  it 'embeds the allowed values' do
    index = 0
    hrefs.each do |href|
      href_path = "#{path}/_embedded/allowedValues/#{index}/_links/self/href"
      is_expected.to be_json_eql(href.to_json).at_path(href_path)
      index += 1
    end
  end
end

shared_examples_for 'links to allowed values via collection link' do
  it 'contains the link to the allowed values' do
    is_expected.to be_json_eql(href.to_json).at_path("#{path}/_links/allowedValues/href")
  end
end

shared_examples_for 'does not link to allowed values' do
  it 'contains no link to the allowed values' do
    is_expected.not_to have_json_path("#{path}/_links/allowedValues")
  end

  it 'does not embed allowed values' do
    is_expected.not_to have_json_path("#{path}/_embedded/allowedValues")
  end
end
