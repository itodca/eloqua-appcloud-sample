class EloquaRequest

  def initialize(site_id, host, base_path)
    if site_id
      eloqua_instance = EloquaInstance.find_by_site_id(site_id)

      if eloqua_instance.present?
        @client_id = eloqua_instance.client_id

        # host defines the Eloqua endpoint
        # default to https://secure.eloqua.com and make sure it starts with https://
        host ||= "https://secure.eloqua.com"
        if host.start_with?("https://") == false
          host = "https://" + host
        end

        @base_url = host
        @base_path = base_path

        # refresh the access token if token expiry does not exist or has passed
        if eloqua_instance.token_expiry.nil? || eloqua_instance.token_expiry < Time.now
          eloqua_instance.refresh
        end

        @conn = Faraday::Connection.new @base_url do |builder|
          builder.use FaradayMiddleware::EncodeJson
          builder.use FaradayMiddleware::Mashify
          builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
          builder.use Eloqua::Middleware::Gzip
          builder.adapter Faraday.default_adapter
        end
        @conn.authorization :Bearer,  eloqua_instance.access_token
      end
    end
  end

  def client_id
    @client_id
  end

  def delete(path, params={})
    @conn.delete("#{@rest_api_path}/#{path}", params)
  end

  def get(path, params={})
    @conn.get do |req|
      req.url @rest_api_path + "/" + path
      req.params = params
      req.headers["accept-encoding"] = "gzip"
    end
  end

  def post(path, body={}, params={})
    @conn.post do |req|
      req.url "#{@rest_api_path}/#{path}"
      req.headers["content-type"] = "application/json"
      req.body = body.to_json
    end
  end

  def put(path, body={}, params={})
    @conn.put do |req|
      req.url "#{@rest_api_path}/#{path}"
      req.headers["content-type"] = "application/json"
      req.body = body.to_json
    end
  end
end