require 'rails_helper'

require 'generators/pg_rspec/scaffold/scaffold_generator'
require 'generators/pg_decorator/pg_decorator_generator'
require 'generators/pg_active_record/model/model_generator'

DESTINATION_PATH = File.expand_path('./../../tmp/generator_testing', __dir__)

describe 'Generators', type: :generator do
  describe 'PgDecoratorGenerator' do
    destination DESTINATION_PATH
    tests PgDecoratorGenerator

    before { prepare_destination }

    it do
      run_generator(['Frontend/Modelo', 'bla:integer'])

      my_assert_file 'app/decorators/modelo_decorator.rb' do |content|
        assert_match(/delegate_all/, content)
      end
    end
  end

  describe 'ScaffoldGenerator' do
    destination DESTINATION_PATH
    tests PgRspec::Generators::ScaffoldGenerator

    before { prepare_destination }

    it do
      run_generator(['Frontend/Modelo', 'bla:integer'])

      my_assert_file 'spec/controllers/frontend/modelos_controller_spec.rb' do |content|
        assert_match(/routing/, content)
        assert_match(/sign_in/, content)
      end
    end
  end

  describe PgActiveRecord::ModelGenerator do
    destination DESTINATION_PATH
    tests described_class

    before { prepare_destination }

    it do
      run_generator(['Frontend/Modelo', 'bla:integer', 'cosa:references', '--activeadmin'])

      my_assert_file 'app/admin/modelos.rb' do |content|
        assert_match(/permit_params.*cosa_id/, content)
      end
    end
  end
end
