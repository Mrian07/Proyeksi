

require 'spec_helper'

describe 'errors routing', type: :routing do
  it { is_expected.to route(:get, '/404').to(controller: 'errors', action: 'not_found') }
  it { is_expected.to route(:get, '/422').to(controller: 'errors', action: 'unacceptable') }
  it { is_expected.to route(:get, '/500').to(controller: 'errors', action: 'internal_error') }
end
