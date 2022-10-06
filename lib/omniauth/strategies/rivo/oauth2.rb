require "omniauth/strategies/oauth2"

module OmniAuth
  module Strategies
    module Rivo
      class OAuth2 < OmniAuth::Strategies::OAuth2
        option :name, "rivo_oauth2"
        option :client_options, {site: "https://loyalty.rivo.io/api/oauth/v1"}
        option :pkce, true

        uid { raw_info["resource_owner_id"] }

        info do
          {
            name: raw_info["resource_owner"]["name"],
            urls: raw_info["resource_owner"]["urls"].transform_keys(&:to_sym)
          }
        end

        extra do
          {
            raw_info: raw_info
          }
        end

        def raw_info
          @raw_info ||= access_token.get("oauth/token/info").parsed
        end
      end
    end
  end
end
