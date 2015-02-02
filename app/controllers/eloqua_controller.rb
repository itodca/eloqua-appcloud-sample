class EloquaController < ApplicationController
  require 'base64'
  require 'openssl'

  skip_before_filter :verify_authenticity_token

  def install

    eloqua_instance = EloquaInstance.where(site_id: params[:site_id]).first_or_initialize
    eloqua_instance.site_name = params[:site_name]
    eloqua_instance.client_id = params[:install_id]
    eloqua_instance.save

    callback_url = url_for :controller => "eloqua", :action => "callback", :id => params[:install_id]
    redirect_to "https://login.eloqua.com/auth/oauth2/authorize?response_type=code&client_id=#{ENV["ELOQUA_APP_ID"]}&redirect_uri=#{callback_url}&state=#{params[:callback]}"

  end

  def status

  end

  def callback
    eloqua_instance = EloquaInstance.find_by_client_id(params[:id])

    if eloqua_instance.present?
      redirect_uri = url_for :controller => "eloqua", :action => "callback", :id => params[:id]
      eloqua_instance.authorize(params[:code], redirect_uri)

      redirect_to params[:state]
    end
  end
end
