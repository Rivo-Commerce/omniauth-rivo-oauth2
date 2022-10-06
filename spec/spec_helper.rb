require "omniauth-rivo-oauth2"

require "rack/test"
require "rack/proxy"
require "webmock/rspec"
require "addressable"

Dir[File.expand_path("../support/**/*.rb", __FILE__)].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    OmniAuth.configure do |config|
      config.request_validation_phase = nil
      config.failure_raise_out_environments = [ENV["RACK_ENV"].to_s]
      config.logger.level = :fatal
    end
  end
end
