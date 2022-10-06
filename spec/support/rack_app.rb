RSpec.shared_context "omniauth_rivo_oauth2_rack_app" do
  include Rack::Test::Methods

  let(:app) do
    described_class = self.described_class
    Rack::Builder.new do
      use OmniAuth::Test::PhonySession
      use described_class, "client_id", "client_secret"
      run Rack::Proxy.new(streaming: false) # Will be intercepted by WebMock
    end.to_app
  end
  let(:omniauth_strategy) { app.instance_variable_get(:@app) }

  before do
    # Any local requests not handled by OmniAuth
    stub_request(
      :any,
      lambda { |uri|
        uri.normalized_host == Addressable::URI.new(host: rack_test_session.default_host).normalized_host
      }
    ).to_return(status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found])
  end
end
