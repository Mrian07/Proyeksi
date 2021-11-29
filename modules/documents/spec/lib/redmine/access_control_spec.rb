
require File.dirname(__FILE__) + '/../../spec_helper'

describe OpenProject::AccessControl do
  describe 'manage documents permission' do
    it 'should be part of the documents project module' do
      permission = OpenProject::AccessControl.permission(:manage_documents)

      expect(permission.project_module).to eql(:documents)
    end
  end

  describe 'view documents permission' do
    it 'should be part of the documents project module' do
      permission = OpenProject::AccessControl.permission(:view_documents)

      expect(permission.project_module).to eql(:documents)
    end
  end
end
