#-- encoding: UTF-8



class Type::QueryGroup < Type::FormGroup
  MEMBER_PREFIX = 'query_'.freeze

  def self.query_attribute?(name)
    name.to_s.match?(/#{Type::QueryGroup::MEMBER_PREFIX}(\d+)/)
  end

  def self.query_attribute_id(name)
    match = name.to_s.match(/#{Type::QueryGroup::MEMBER_PREFIX}(\d+)/)

    match ? match[1] : nil
  end

  def query_attribute_name
    :"query_#{query.id}"
  end

  def group_type
    :query
  end

  def ==(other)
    other.is_a?(self.class) &&
      key == other.key &&
      type == other.type &&
      query.to_json == other.attributes.to_json
  end

  alias :query :attributes

  def members
    [attributes]
  end

  def active_members(_project)
    [members]
  end
end
