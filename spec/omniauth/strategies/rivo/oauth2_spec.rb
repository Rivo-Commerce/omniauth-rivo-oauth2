RSpec.describe OmniAuth::Strategies::Rivo::OAuth2 do
  include_context "omniauth_rivo_oauth2_rack_app"

  include WebMockHelpers::OmniAuth::Rivo::OAuth2

  let(:shopify_shop_name) { "example" }
  let(:resource_owner) { OpenStruct.new(id: 123, name: "example") }

  before do
    stub_authorization
    stub_access_token
    stub_token_info
  end

  context "when requesting an authorization code" do
    subject do
      post "/auth/rivo_oauth2"
      follow_redirect! # Redirect from strategy to authorization page
      follow_redirect! # Callback from authorization page to strategy
    end

    context "when the user authorizes the request" do
      before { subject }

      it "sets the tokens" do
        expect(last_request.env["omniauth.auth"]["credentials"]["token"]).not_to be_empty
        expect(last_request.env["omniauth.auth"]["credentials"]["refresh_token"]).not_to be_empty
      end

      it "has a non-expired token" do
        expect(Time.at(last_request.env["omniauth.auth"]["credentials"]["expires_at"]))
          .to be > Time.now
      end

      it "sets the provider to rivo_oauth2" do
        expect(last_request.env["omniauth.auth"]["provider"]).to eq "rivo_oauth2"
      end

      it "sets the UID to the resource owner's ID" do
        expect(last_request.env["omniauth.auth"]["uid"]).to eq resource_owner.id
      end

      it "sets the resource owner's name" do
        expect(last_request.env["omniauth.auth"]["info"][:name]).to eq resource_owner.name
      end

      it "sets the resource owner's URLs" do
        expect(last_request.env["omniauth.auth"]["info"][:urls][:shopify])
          .to eq "https://#{shopify_shop_name}.myshopify.com/"
      end
    end

    context "when the user denies the request" do
      before { stub_denied_authorization }

      it "detects that access was denied" do
        expect { subject }.to raise_error(
          an_instance_of(OmniAuth::Strategies::OAuth2::CallbackError)
            .and(having_attributes(error: "access_denied"))
        )
      end
    end
  end
end
