#-- encoding: UTF-8



class Grids::CreateService < ::BaseServices::Create
  include ::Shared::ServiceContext

  protected

  def instance(attributes)
    scope = attributes.delete(:scope)
    ::Grids::Factory.build(scope, user)
  end
end
