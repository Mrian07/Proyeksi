#-- encoding: UTF-8

class Queries::UpdateService < Queries::BaseService
  def initialize(**args)
    super(**args)

    self.contract_class = Queries::UpdateContract
  end

  def call(query)
    result, errors = update query

    service_result result, errors, query
  end

  private

  def update(query)
    menu_item = prepare_menu_item query

    result = nil
    errors = nil

    query.transaction do
      result, errors = validate_and_save(query, user)

      if !result
        raise ActiveRecord::Rollback
      elsif menu_item && !menu_item.save
        result = false
        merge_errors(errors, menu_item)
      end
    end

    [result, errors]
  end

  def prepare_menu_item(query)
    if query.changes.include?('name') &&
      query.query_menu_item

      menu_item = query.query_menu_item

      menu_item.title = query.name

      menu_item
    end
  end

  def merge_errors(errors, menu_item)
    menu_item.errors.each do |sym, message|
      errors.add(sym, message)
    end
  end
end
