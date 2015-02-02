class IntegrateController < ApplicationController
  require "addressable/uri"
  require "base64"
  require "openssl"

  skip_before_filter :verify_authenticity_token

  def create_action
    #create integrate action
    #send eloqua response
    puts "REQUEST BODY"
    puts request.body.read.to_json

    digest  = OpenSSL::Digest.new('sha1')
    oauth_signature = params[:oauth_signature]
    escaped_oauth_signature = CGI.escape(oauth_signature)
    querystring = request.query_string
    querystring_no_sig = request.query_string.gsub("&oauth_signature=" + CGI.escape(oauth_signature), "")
    uri = Addressable::URI.parse(request.original_url)
    uri.query_values = uri.query_values.except("oauth_signature")

    puts "OAUTH SIG: " + oauth_signature
    puts "SITE: #{uri.site}"
    puts "QUERYSTRING 1: #{uri.query}"
    oauth_string_1 = "POST&" + CGI.escape(uri.site + uri.path) + "&" + CGI.escape(uri.query)
    puts "OAUTH STRING 1: #{oauth_string_1}"
    calculated_hmac_1 = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV["ELOQUA_APP_SECRET"], oauth_string_1)).strip
    puts "CALCULATED HMAC 1: " + calculated_hmac_1

    puts "QUERYSTRING 2: #{querystring}"
    oauth_string_2 = "POST&" + CGI.escape(uri.site + uri.path) + "&" + CGI.escape(querystring)
    puts "OAUTH STRING 2: #{oauth_string_2}"
    calculated_hmac_2 = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV["ELOQUA_APP_SECRET"], oauth_string_2)).strip
    puts "CALCULATED HMAC 2: " + calculated_hmac_2

    puts "QUERYSTRING 3: #{querystring_no_sig}"
    oauth_string_3 = "POST&" + CGI.escape(uri.site + uri.path) + "&" + CGI.escape(querystring_no_sig)
    puts "OAUTH STRING 3: #{oauth_string_3}"
    calculated_hmac_3 = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV["ELOQUA_APP_SECRET"], oauth_string_3)).strip
    puts "CALCULATED HMAC 3: " + calculated_hmac_3

    @response = {}
    @response[:recordDefinition] = {}
    @response[:recordDefinition][:ContactID] = "{{Contact.Id}}"
    @response[:recordDefinition][:EmailAddress] = "{{Contact.Field(C_EmailAddress)}}"

    #integrate_eloqua_action = IntegrateEloquaActions.where(site_id: params[:site_id], instance_id: params[:instance_id]).first_or_create
    render json: @response
  end

  def configure_action
  end

  def menu
    puts request.body.read
    @request = request.body.read
  end

  def notify_action
  end

end
