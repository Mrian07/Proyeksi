

require 'spec_helper'

describe 'Boards routing', type: :routing do
  it {
    is_expected
      .to route(:get, '/projects/foobar/boards/state')
      .to(controller: 'boards/boards', action: 'index', project_id: 'foobar', state: 'state')
  }

  it {
    is_expected
      .to route(:get, '/boards/state')
      .to(controller: 'boards/boards', action: 'index', state: 'state')
  }
end
