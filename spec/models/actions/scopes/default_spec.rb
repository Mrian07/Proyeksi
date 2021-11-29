

require 'spec_helper'

describe Actions::Scopes::Default, type: :model do
  subject(:scope) { Action.default }

  describe '.default' do
    let(:expected) do
      # This complicated and programmatic way is chosen so that the test can deal with additional actions being defined
      item = ->(permission, namespace, action, global, module_name) {
        ["#{API::Utilities::PropertyNameConverter.from_ar_name(namespace.to_s.singularize).pluralize.underscore}/#{action}",
         permission.to_s,
         global,
         module_name&.to_s]
      }

      OpenProject::AccessControl
        .contract_actions_map
        .map do |permission, v|
          v[:actions].map { |vk, vv| vv.map { |vvv| item.call(permission, vk, vvv, v[:global], v[:module]) } }
        end.flatten(2)
    end

    it 'contains all actions' do
      expect(scope.pluck(:id, :permission, :global, :module))
        .to match_array(expected)
    end
  end
end
