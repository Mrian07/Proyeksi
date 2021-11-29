#-- encoding: UTF-8



# This is to ensure that we are unaffected by
# CVE-2015-3226: https://groups.google.com/forum/#!msg/rubyonrails-security/7VlB_pck3hU/3QZrGIaQW6cJ
# The report states that 3.2 is affected by the vulnerability. However,
# the test copied from the rails patch (adapted to rspec) passed without fixes
# in the productive code.
#
# It should be safe to remove this when OP is on rails >= 4.1

require 'spec_helper'

describe ActiveSupport do
  active_support_default = ActiveSupport.escape_html_entities_in_json

  after do
    ActiveSupport.escape_html_entities_in_json = active_support_default
  end

  it 'escapes html entities in json' do
    ActiveSupport.escape_html_entities_in_json = true
    expected_output = "{\"\\u003c\\u003e\":\"\\u003c\\u003e\"}"

    expect(ActiveSupport::JSON.encode('<>' => '<>')).to eql(expected_output)
  end
end
