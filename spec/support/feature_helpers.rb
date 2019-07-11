# frozen_string_literal: true

support :routing_helpers

module FeatureHelpers
  include RoutingHelpers

  def accept_alert
    page.driver.browser.switch_to.alert.accept
  end

  def click_css(selector)
    page.find(:css, selector).click
  end

  def do_not_raise_server_errors
    original_raise_server_errors = Capybara.raise_server_errors
    Capybara.raise_server_errors = false
    yield
    Capybara.raise_server_errors = original_raise_server_errors
  end

  def expect_404
    expect_content 'Not Found'
  end

  # def expect_404
  #   do_not_raise_server_errors do
  #     yield
  #     expect_content 'Not Found'
  #   end
  # end

  def expect_content(content)
    raise 'content cannot be blank' if content.blank?

    expect(page).to have_content(content, wait: 10)
  end

  def expect_count(selector, num = 1)
    expect(page).to have_css(selector, count: num)
  end

  def expect_css_link(url)
    expect(page).to have_selector(:css, "link[href=\"#{url}\"]", visible: false)
  end

  def expect_path(*args)
    expect(page).to have_current_path(*args)
  end

  def screenshot
    screenshot_and_save_page
    screenshot_and_open_image
  end
end
