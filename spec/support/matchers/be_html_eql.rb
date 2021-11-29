#-- encoding: UTF-8



::RSpec::Matchers.define :be_html_eql do |expected|
  def path
    @path
  end

  def html(html)
    Nokogiri::HTML(html)
  end

  match do |actual|
    @actual = if path
                html(actual).css(path)
              else
                actual
              end

    raise "Path specified is missing (#{path.inspect})" if path && @actual.empty?

    EquivalentXml.equivalent?(self.actual, expected, {})
  end

  chain :at_path do |path|
    @path = path
  end

  chain :within_path do |path|
    @path = path + ' > *'
  end

  should_message = ->(actual) do
    ['expected:', expected.to_s, 'got:', actual.to_s].join("\n")
  end

  should_not_message = ->(actual) do
    ['expected:', actual.to_s, 'not to be equivalent to:', expected.to_s].join("\n")
  end

  failure_message &should_message
  failure_message_when_negated &should_not_message
end
