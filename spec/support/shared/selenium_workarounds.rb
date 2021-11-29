

# Ensuring that send_keys fill in the entire string
# This may happen with ChromeDriver versions and send_keys
# https://bugs.chromium.org/p/chromedriver/issues/detail?id=1771
module SeleniumWorkarounds
  def ensure_value_is_input_correctly(input, value:)
    # Wait a bit to insert the value
    sleep(0.5)
    input.set value
    sleep(0.5)

    found_value = input.value
    raise "Found value #{found_value}, but expected #{value}." unless found_value == value
  end
end
