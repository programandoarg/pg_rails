require "generators/pundit/policy/policy_generator"

module Pundit
  module Generators
    class PolicyGenerator < ::Rails::Generators::NamedBase
      remove_hook_for :test_framework
    end
  end
end
