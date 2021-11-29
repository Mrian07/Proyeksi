#-- encoding: UTF-8



class Queries::WorkPackages::Columns::RelationToTypeColumn < Queries::WorkPackages::Columns::RelationColumn
  def initialize(type)
    super

    set_name! type
    self.type = type
  end

  def set_name!(type)
    self.name = "relations_to_type_#{type.id}".to_sym
  end

  def caption
    I18n.t(:'activerecord.attributes.query.relations_to_type_column',
           type: type.name)
  end

  def self.instances(context = nil)
    if !granted_by_enterprise_token
      []
    elsif context
      context.types
    else
      Type.all
    end.map { |type| new(type) }
  end
end
