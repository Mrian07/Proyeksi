#-- encoding: UTF-8



class Type::FormGroup
  attr_accessor :key,
                :attributes,
                :type

  def initialize(type, key, attributes)
    self.key = key
    self.attributes = attributes
    self.type = type
  end

  ##
  # Returns the symbol key, if it is not translated
  def internal_key?
    key.is_a?(Symbol)
  end

  ##
  # Translate the given attribute group if its internal
  # (== if it's a symbol)
  def translated_key
    if internal_key?
      I18n.t(Type.default_groups[key], default: key.to_s)
    else
      key
    end
  end

  def members
    raise NotImplementedError
  end

  def active_members(_project)
    raise NotImplementedError
  end
end
