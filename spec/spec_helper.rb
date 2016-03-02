require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = File.join __dir__, 'fixtures/vcr_cassettes'
  config.hook_into :webmock
end

