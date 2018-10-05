require "selenium/webdriver"

Capybara.register_driver :chrome do |app|
  if ENV["SLOW"].present?
    module ::Selenium::WebDriver::Remote
      class Bridge
        alias old_execute execute

        def execute(*args)
          sleep(0.2)
          old_execute(*args)
        end
      end
    end
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.javascript_driver = ENV["SLOW"].present? ? :chrome : :headless_chrome

# Enable automatic_label_click to support our custom checkbox and radio button
# implementations. When this option is disabled, our JS tests fail as the driver
# 'sees' the controls as 'non-visible'.
#
Capybara.automatic_label_click = true
