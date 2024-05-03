# frozen_string_literal: true

require 'rails_helper'

describe 'Sign in', :js do
  shared_examples 'sign_in' do
    subject do
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: password
      find('input[type=submit]').click
    end

    let(:password) { 'pass1234' }
    let!(:user) { create :user, password: }

    it do
      subject
      expect(page).to have_text :all, 'No hay categorías de cosas aún'
    end
  end

  # Capybara.drivers.keys
  drivers = %i[
    selenium_headless
    selenium_chrome_headless
    selenium_chrome_headless_notebook
    selenium_chrome_headless_iphone
  ]
  # drivers = %i[selenium_chrome_headless_notebook]
  # drivers = %i[selenium_chrome_debugger]
  # drivers = %i[selenium]
  # drivers = %i[selenium_chrome]
  drivers = [ENV['DRIVER'].to_sym] if ENV['DRIVER'].present?

  drivers.each do |driver|
    context("with driver '#{driver}'", driver:) do
      include_examples 'sign_in'
    end
  end
end
