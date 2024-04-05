require 'rails_helper'

describe Navbar do
  let(:user) { create :user }
  let(:instancia) { described_class.new(user) }

  describe '#add_html' do
    subject { instancia.add_html(some_html) }

    let(:some_html) { '<p>Hola</p>' }

    it do
      expect { subject }.to(change(instancia, :extensiones))
    end
  end

  describe '#add_item' do
    subject { instancia.add_item('key', some_item) }

    let(:some_item) do
      {
        name: 'Título',
        path: 'root_path',
        policy: 'true'
      }
    end

    it do
      expect { subject }.to(change { instancia.bar('key') })
    end
  end
end
