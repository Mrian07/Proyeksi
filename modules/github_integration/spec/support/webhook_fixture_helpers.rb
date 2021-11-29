

require 'json'

module WebhookFixtureHelpers
  FIXTURES_PATH = File.join(File.dirname(__FILE__), '../fixtures/github_webhooks')

  # Params:
  # * replacements: A `Hash` containing replacement values for placeholders in the fixture files,
  #   usually:
  #   ```
  #   {
  #     title: "A PR title",
  #     body: "A PR body",
  #   }
  #   ```
  def webhook_payload(event, name, replacements = {})
    replacements = replacements.map { |key, value| ["${#{key}}", value.gsub("\n", '\n')] }.to_h
    content = File.read(File.join(FIXTURES_PATH, "#{event}/#{name}.json"))
    content.gsub!(/\$\{[^{]+?\}/, replacements)
    JSON.parse(content)
  end
end

RSpec.configure do |config|
  config.include WebhookFixtureHelpers
end
