RSpec.configure do |config|
  config.before(:each) do
    Current.user = nil
    Current.namespace = nil
  end
end
