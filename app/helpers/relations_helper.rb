#-- encoding: UTF-8



module RelationsHelper
  def collection_for_relation_type_select
    values = Relation::TYPES
    values.keys.sort { |x, y| values[x][:order] <=> values[y][:order] }.map { |k| [I18n.t(values[k][:name]), k] }
  end
end
