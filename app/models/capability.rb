#-- encoding: UTF-8



class Capability < ApplicationRecord
  include Tableless
  include Scopes::Scoped

  scopes :default

  default_scope { default }

  belongs_to :context, class_name: 'Project'
  belongs_to :principal

  attribute :action, :text, default: nil
  attribute :context_id, :integer, default: nil
  attribute :principal_id, :integer, default: nil
end
