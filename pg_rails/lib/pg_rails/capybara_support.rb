def add_emulate_device(browser_options, emulate_device)
  if emulate_device == 'notebook'
    browser_options.add_emulation(device_metrics: { width: 800, height: 400, pixelRatio: 1, touch: true })
  else
    browser_options.add_emulation(device_name: emulate_device)
  end

  browser_options
end

def default_options(headless:)
  options = Selenium::WebDriver::Chrome::Options.new
  options.args << '--disable-site-isolation-trials'
  # options.args << '--start-maximized'

  if headless
    options.args << '--headless'
    options.args << '--disable-gpu' if Gem.win_platform?
  end

  options
end

def chrome_driver_gen(headless: true, emulate_device: nil, debugger: false)
  lambda do |app|
    Capybara::Selenium::Driver.load_selenium
    browser_options = default_options(headless:)

    if debugger
      port = ENV.fetch('CHROME_PORT') { '9014' }
      browser_options.debugger_address = "127.0.0.1:#{port}"
    end

    browser_options = add_emulate_device(browser_options, emulate_device) if emulate_device

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
  end
end

Capybara.register_driver :selenium_chrome, &chrome_driver_gen(headless: false)
Capybara.register_driver :selenium_chrome_notebook, &chrome_driver_gen(headless: false, emulate_device: 'notebook')
Capybara.register_driver :selenium_chrome_iphone, &chrome_driver_gen(headless: false, emulate_device: 'iPhone 6')
Capybara.register_driver :selenium_chrome_headless, &chrome_driver_gen(headless: true)
Capybara.register_driver :selenium_chrome_headless_notebook,
                         &chrome_driver_gen(headless: true, emulate_device: 'notebook')
Capybara.register_driver :selenium_chrome_headless_iphone,
                         &chrome_driver_gen(headless: true, emulate_device: 'iPhone 6')
Capybara.register_driver :selenium_chrome_debugger, &chrome_driver_gen(headless: false, debugger: true)

Capybara.javascript_driver = ENV.fetch('WEBDRIVER') { 'selenium_chrome_notebook' }.to_sym
