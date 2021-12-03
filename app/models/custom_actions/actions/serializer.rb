#-- encoding: UTF-8

class CustomActions::Actions::Serializer
  def self.load(value)
    return [] unless value

    YAML
      .safe_load(value, [Symbol])
      .map do |key, values|
      klass = nil

      CustomActions::Register
        .actions
        .detect do |a|
        klass = a.for(key)
      end

      klass ||= CustomActions::Actions::Inexistent

      klass.new(values)
    end.compact
  end

  def self.dump(actions)
    YAML::dump(actions.map { |a| [a.key, a.values.map(&:to_s)] })
  end
end
