module WebMockHelpers
  module OmniAuth
    module Rivo
      module OAuth2
        def stub_authorization
          # GET /oauth/authorize
          stub_request(:get, omniauth_strategy.client.authorize_url).with_any_query.to_return do |request|
            {
              status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:found],
              headers: {
                location:
                  Addressable::URI.parse(request.uri.query_values["redirect_uri"]).tap do |uri|
                    uri.query_values =
                      (uri.query_values || {}).merge(
                        code: "authorization_code",
                        state: request.uri.query_values["state"]
                      )
                  end
              }
            }
          end
        end

        def stub_denied_authorization
          # GET /oauth/authorize
          stub_request(:get, omniauth_strategy.client.authorize_url).with_any_query.to_return do |request|
            {
              status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:found],
              headers: {
                location:
                  Addressable::URI.parse(request.uri.query_values["redirect_uri"]).tap do |uri|
                    uri.query_values =
                      (uri.query_values || {}).merge(
                        state: request.uri.query_values["state"],
                        error: "access_denied",
                        error_description: "The resource owner or authorization server denied the request."
                      )
                  end
              }
            }
          end
        end

        def stub_access_token
          # POST /oauth/token
          stub_request(:post, omniauth_strategy.client.token_url).to_return_json(
            body: {
              access_token: "access_token",
              token_type: "Bearer",
              expires_in: 7_200,
              refresh_token: "refresh_token",
              scope: "example_scope",
              created_at: Time.now.to_i
            }
          )
        end

        def stub_token_info
          # GET /oauth/token/info
          stub_request(:get, omniauth_strategy.client.connection.build_url("oauth/token/info")).to_return_json(
            body: {
              resource_owner_id: resource_owner.id,
              scope: ["example_scope"],
              expires_in: 7_200,
              application: {
                uid: "client_id"
              },
              created_at: Time.now.to_i,
              resource_owner: {
                id: resource_owner.id,
                name: resource_owner.name,
                urls: {
                  shopify:
                    Addressable::URI.new(
                      scheme: "https",
                      host: "#{shopify_shop_name}.myshopify.com",
                      path: "/"
                    ).to_s
                }
              }
            }
          )
        end
      end
    end
  end
end
