#-- encoding: UTF-8



def aggregate_mocked_settings(example, settings)
  # We have to manually check parent groups for with_settings:,
  # since they are being ignored otherwise
  example.example_group.module_parents.each do |parent|
    if parent.respond_to?(:metadata) && parent.metadata[:with_settings]
      settings.reverse_merge!(parent.metadata[:with_settings])
    end
  end

  settings
end

RSpec.configure do |config|
  config.before(:each) do |example|
    settings = example.metadata[:with_settings]
    if settings.present?
      settings = aggregate_mocked_settings(example, settings)

      allow(Setting).to receive(:[]).and_call_original

      settings.each do |k, v|
        name = k.to_s.sub(/\?\Z/, '') # remove trailing question mark if present to get setting name

        raise "#{k} is not a valid setting" unless Setting.respond_to?(name)

        expect(name).not_to start_with("localized_"), -> do
          base = name[10..-1]

          "Don't use `#{name}` in `with_settings`. Do this: `with_settings: { #{base}: { \"en\" => \"#{v}\" } }`"
        end

        allow(Setting).to receive(:[]).with(name).and_return v
        allow(Setting).to receive(:[]).with(name.to_sym).and_return v
      end
    end
  end
end
