require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.default_cassette_options = {
    match_requests_on: %i[uri method],
    record: :once
  }
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.around(:example, :vcr_cassettes) do |example|
    cassettes = example.metadata[:vcr_cassettes].map { |cas_name| { name: cas_name } }
    VCR.use_cassettes(cassettes) do
      example.run
    end
  end
end
