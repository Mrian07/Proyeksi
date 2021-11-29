

require 'spec_helper'

describe 'workflows routes', type: :routing do
  it { expect(get('/workflows')).to route_to('workflows#show') }

  it { expect(get('/workflows/edit')).to route_to('workflows#edit') }
  it { expect(patch('/workflows')).to route_to('workflows#update') }

  it { expect(get('/workflows/copy')).to route_to('workflows#copy') }
  it { expect(post('/workflows/copy')).to route_to('workflows#copy') }
end
