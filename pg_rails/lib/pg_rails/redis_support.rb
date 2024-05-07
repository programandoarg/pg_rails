RSpec.configure do |config|
  config.before(:each) do
    Kredis.redis
    Kredis.clear_all
  end
end
