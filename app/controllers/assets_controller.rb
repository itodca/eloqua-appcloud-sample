class AssetsController < ApplicationController

  def campaign
    @campaign = eloqua_rest_request.get("assets/campaign/#{params[:id]}").body
  end

  def contact_segment
    @contact_segment = eloqua_rest_request.get("assets/contact/segment/#{params[:id]}").body
  end

  def email
    @email = eloqua_rest_request.get("assets/email/#{params[:id]}").body
  end

  def form
    @form = eloqua_rest_request.get("assets/form/#{params[:id]}").body
  end

  def landingpage
    @landingpage = eloqua_rest_request.get("assets/landingpage/#{params[:id]}").body
  end

end
