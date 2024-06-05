require 'rails_helper'

fdescribe 'Alertas' do
  before do
    driven_by ENV['DRIVER']&.to_sym || :selenium_chrome_headless_iphone
  end

  it 'los toasts desaparecen' do
    visit '/rails/view_components/alert_component/default'
    expect(page).to have_text('Los toasts van a desaparecer').exactly(5)
    # Desaparecieron
    expect(page).to have_no_text('Los toasts van a desaparecer', wait: 10)
  end

  it 'los dismissibles se cierran' do
    visit '/rails/view_components/alert_component/dismisible'
    expect(page).to have_text('este dismisible se va a cerrar')
    find('.btn-close').click
    expect(page).to have_no_text('este dismisible se va a cerrar')
  end
end
