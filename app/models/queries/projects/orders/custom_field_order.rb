#-- encoding: UTF-8

class Queries::Projects::Orders::CustomFieldOrder < Queries::Orders::Base
  self.model = Project.all

  validates :custom_field, presence: { message: I18n.t(:'activerecord.errors.messages.does_not_exist') }

  def self.key
    /cf_(\d+)/
  end

  def custom_field
    @custom_field ||= begin
                        id = self.class.key.match(attribute)[1]

                        ProjectCustomField.visible.find_by_id(id)
                      end
  end

  def scope
    super.select(custom_field.order_statements)
  end

  private

  def order
    joined_statement = custom_field.order_statements.map do |statement|
      Arel.sql("#{statement} #{direction}")
    end

    model.order(joined_statement)
  end
end
