#-- encoding: UTF-8



class Action < ApplicationRecord
  include Tableless
  include Scopes::Scoped

  scopes :default

  default_scope { default }

  attribute :id, :text, default: nil
  attribute :permission, :text, default: nil
  attribute :global, :boolean, default: false
  attribute :module, :text, default: false
end
