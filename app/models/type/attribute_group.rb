#-- encoding: UTF-8

class Type::AttributeGroup < Type::FormGroup
  def members
    # The attributes might not be present anymore, for instance when you remove
    # a plugin leaving an empty group behind. If we did not delete such a
    # group, the admin saving such a form configuration would encounter an
    # unexpected/unexplicable validation error.
    valid_keys = type.work_package_attributes.keys

    (attributes & valid_keys)
  end

  def group_type
    :attribute
  end

  def ==(other)
    other.is_a?(self.class) &&
      key == other.key &&
      type == other.type &&
      attributes == other.attributes
  end

  def active_members(project)
    members.select do |prop|
      type.passes_attribute_constraint?(prop, project: project)
    end
  end
end
