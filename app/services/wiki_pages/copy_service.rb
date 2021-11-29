#-- encoding: UTF-8



class WikiPages::CopyService
  include ::Shared::ServiceContext
  include Contracted

  attr_accessor :user,
                :model,
                :contract_class

  def initialize(user:, model:, contract_class: WikiPages::CreateContract)
    self.user = user
    self.model = model
    self.contract_class = contract_class
  end

  def call(send_notifications: true, **attributes)
    in_context(model, send_notifications) do
      copy(attributes)
    end
  end

  protected

  def copy(attribute_override)
    attributes = copied_attributes(attribute_override)

    create(attributes)
  end

  def create(attributes)
    WikiPages::CreateService
      .new(user: user,
           contract_class: contract_class)
      .call(attributes.symbolize_keys)
  end

  # Copy the wiki page attributes together with the wiki page content attributes
  def copied_attributes(override)
    model
      .attributes
      .merge(model.content.attributes)
      .slice(*writable_attributes)
      .merge(override)
  end

  def writable_attributes
    instantiate_contract(model, user)
      .writable_attributes
  end
end
