# frozen_string_literal: true

require 'generators/pundit/policy/policy_generator'

class PgPunditGenerator < Pundit::Generators::PolicyGenerator
  source_root File.expand_path('templates', __dir__)

  remove_hook_for :test_framework

  def namespace # :doc:
    nil
  end
  def class_path # :doc:
    []
  end
  def create_module_file
  end
end
