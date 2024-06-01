require 'rails_helper'

fdescribe 'Enviar email' do
  include ActiveJob::TestHelper

  subject do
    fill_in 'email_from_address', with: Faker::Internet.email
    fill_in 'email_from_name', with: Faker::Name.name
    fill_in 'email_reply_to', with: Faker::Internet.email
    fill_in 'email_body_input', with: Faker::Lorem.sentence
    fill_in 'email_subject', with: Faker::Lorem.sentence
    click_on 'Enviar'
    expect(page).to have_text 'revisá los campos obligatorios'
    fill_in 'email_to', with: Faker::Internet.email
    click_on 'Enviar'
  end

  around do |example|
    perform_enqueued_jobs do
      example.run
    end
  end

  before do
    driven_by :selenium
    login_as create(:user, :developer)
    visit '/a/emails/new'
  end

  it do
    subject
    expect(page).to have_text 'sent'
  end
end
