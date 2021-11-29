

# Scrolls a native element into view using JS
def scroll_to_element(element)
  script = <<-JS
    arguments[0].scrollIntoView(true);
  JS
  Capybara.current_session.driver.browser.execute_script(script, element.native)
end

def scroll_to_and_click(element)
  retry_block do
    scroll_to_element(element)
    sleep 0.2
    element.click
  end
end

def expect_element_in_view(element)
  script = <<-JS
    (function(el) {
      var rect = el.getBoundingClientRect();
      return (
        rect.top >= 0 && rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
      );
    })(arguments[0]);
  JS

  retry_block do
    result = page.evaluate_script(script, element.native)
    raise "Expected #{element} to be visible in window, but wasn't." unless result
  end
end
