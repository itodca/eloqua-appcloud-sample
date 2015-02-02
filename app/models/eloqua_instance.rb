class EloquaInstance < ActiveRecord::Base
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  def authorize(code, redirect_uri)
    get_tokens({ :grant_type => "authorization_code", :code => code, :redirect_uri => redirect_uri})
  end

  def refresh
    get_tokens({ :grant_type => "refresh_token", :refresh_token => self.refresh_token, :scope => "full"})
  end

  def get_tokens(request_body)
    conn = Faraday::Connection.new "https://login.eloqua.com/auth/oauth2/token" do |builder|
      builder.use FaradayMiddleware::EncodeJson
      builder.use FaradayMiddleware::Mashify
      builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      builder.adapter Faraday.default_adapter
    end
    conn.basic_auth ENV["ELOQUA_APP_ID"], ENV["ELOQUA_APP_SECRET"]

    # callback_url = url_for :controller => "eloqua", :action => "callback", :id => self.client_id
    # request_body[:redirect_uri] = callback_url

    response = conn.post do |req|
      req.headers["content-type"] = "application/json"
      req.body = request_body.to_json
    end

    eloqua_response = response.body
    self.access_token = eloqua_response.access_token
    self.token_expiry = Time.now + eloqua_response.expires_in.to_i - 100
    self.refresh_token = eloqua_response.refresh_token
    self.save
  end
end
