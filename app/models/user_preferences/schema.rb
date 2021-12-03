class UserPreferences::Schema
  class << self
    PATH = Rails.root.join('config/schemas/user_preferences.schema.json')

    class_attribute :extensions,
                    default: {}

    def schema
      @schema ||= begin
                    json = JSON::parse(File.read(PATH))
                    extensions.each do |path, extension|
                      existing = json.dig(*path.split('/'))

                      existing.merge!(extension)
                    end

                    json
                  end
    end

    def merge!(path, hash)
      extensions[path] = hash
    end

    def properties
      @properties ||= schema.dig('definitions', 'UserPreferences', 'properties')&.keys || []
    end
  end
end
