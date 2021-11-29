#-- encoding: UTF-8



class Queries::WorkPackages::Columns::RelationOfTypeColumn < Queries::WorkPackages::Columns::RelationColumn
  def initialize(type)
    super

    self.type = type
  end

  def name
    "relations_of_type_#{type[:sym]}".to_sym
  end

  def sym
    type[:sym]
  end
  alias :relation_type :sym

  def caption
    I18n.t(:'activerecord.attributes.query.relations_of_type_column',
           type: I18n.t(type[:sym_name]))
  end

  def self.instances(_context = nil)
    return [] unless granted_by_enterprise_token

    Relation::TYPES.map { |_key, type| new(type) }
  end
end
