

require 'spec_helper'

shared_examples_for 'API V3 formattable' do |property|
  it { is_expected.to have_json_path(property) }

  it { is_expected.to be_json_eql(format.to_json).at_path(property + '/format') }

  it { is_expected.to be_json_eql(raw.to_json).at_path(property + '/raw') }

  it do
    if defined?(html)
      is_expected.to be_json_eql(html.to_json).at_path(property + '/html')
    end
  end
end
