require 'rails_helper'
# rubocop:disable RSpec/ExampleLength
describe PgEngine::PgRailsHelper do
  describe '#img_placeholder' do
    it 'si no es fade_in' do
      asd = img_placeholder(src: 'bla', fade_in: false, class: 'img-fluid', style: 'color:red')
      expectation = <<~HTML
        <img class="img-fluid" style="color:red" src="/images/bla" />
      HTML
      expect(asd).to eq expectation.split("\n").map(&:strip).join
    end

    it 'si tiene style' do
      asd = img_placeholder(src: 'bla', fade_in: true, class: 'img-fluid', style: 'color:red')
      expectation = <<~HTML
        <div class="placeholder-glow" style="width: 100%; height: 100%">
          <div class="placeholder w-100 h-100">
          <img data-controller="fadein_onload" class="img-fluid" style="color:red;display:none" src="/images/bla" />
          </div>
        </div>
      HTML
      expect(asd).to eq expectation.split("\n").map(&:strip).join
    end

    it 'si no tiene style' do
      asd = img_placeholder(src: 'bla', fade_in: true, class: 'img-fluid')
      expectation = <<~HTML
        <div class="placeholder-glow" style="width: 100%; height: 100%">
          <div class="placeholder w-100 h-100">
          <img data-controller="fadein_onload" class="img-fluid" style="display:none" src="/images/bla" />
          </div>
        </div>
      HTML
      expect(asd).to eq expectation.split("\n").map(&:strip).join
    end
  end
end
# rubocop:enable RSpec/ExampleLength
