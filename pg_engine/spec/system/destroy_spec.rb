# frozen_string_literal: true

require 'rails_helper'

describe 'Sign in' do
  include ActionView::RecordIdentifier

  shared_examples 'destroy from index' do
    subject do
      accept_confirm do
        find("##{dom_id(cosa)} span[title=Eliminar] a").click
      end
      sleep 1
    end

    let(:user) { create :user, :developer }
    let!(:cosa) { create :cosa }

    before do
      create_list :cosa, 5
      login_as user
      visit '/frontend/cosas'
    end

    it do
      expect { subject }.to change { page.find_all('tbody tr').length }.from(6).to(5)
    end
  end

  shared_examples 'destroy from show' do
    subject do
      accept_confirm do
        find('.btn-toolbar span[title=Eliminar] a').click
      end
      sleep 1
    end

    let(:user) { create :user, :developer }
    let!(:cosa) { create :cosa }

    before do
      login_as user
      visit "/frontend/cosas/#{cosa.to_param}"
    end

    it do
      subject
      expect(page).to have_current_path('/frontend/cosas')
      expect(page).to have_text('Coso borrado')
    end
  end

  # drivers = %i[
  #   selenium_headless
  #   selenium_chrome_headless
  #   selenium_chrome_headless_notebook
  #   selenium_chrome_headless_iphone
  # ]
  drivers = %i[selenium_chrome_headless_iphone]
  drivers = [ENV['DRIVER'].to_sym] if ENV['DRIVER'].present?

  drivers.each do |driver|
    context("with driver '#{driver}'") do
      before do
        driven_by driver
      end

      it_behaves_like 'destroy from index'
      it_behaves_like 'destroy from show'
    end
  end
end
