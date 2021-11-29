#-- encoding: UTF-8



class WithConfig
  attr_reader :context

  def initialize(context)
    @context = context
  end

  ##
  # We need this so calls to rspec mocks (allow, expect etc.) will work here as expected.
  def method_missing(method, *args, &block)
    if context.respond_to?(method)
      context.send method, *args, &block
    else
      super
    end
  end

  ##
  # Stubs the given configurations.
  #
  # @config [Hash] Hash containing the configurations with keys as seen in `configuration.rb`.
  def before(example, config)
    allow(OpenProject::Configuration).to receive(:[]).and_call_original

    aggregate_mocked_configuration(example, config)
      .with_indifferent_access
      .each(&method(:stub_key))
  end

  def stub_key(key, value)
    allow(OpenProject::Configuration)
      .to receive(:[])
      .with(key.to_s)
      .and_return(value)

    allow(OpenProject::Configuration)
      .to receive(:[])
      .with(key.to_sym)
      .and_return(value)
  end

  def aggregate_mocked_configuration(example, config)
    # We have to manually check parent groups for with_config:,
    # since they are being ignored otherwise
    example.example_group.module_parents.each do |parent|
      if parent.respond_to?(:metadata) && parent.metadata[:with_config]
        config.reverse_merge!(parent.metadata[:with_config])
      end
    end

    config
  end
end

RSpec.configure do |config|
  config.before(:each) do |example|
    with_config = example.metadata[:with_config]

    WithConfig.new(self).before example, with_config if with_config.present?
  end
end
