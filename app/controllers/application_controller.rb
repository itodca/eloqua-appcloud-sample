class ApplicationController < ActionController::Base
  helper_method :eloqua_bulk_request
  helper_method :eloqua_cloud_request
  helper_method :eloqua_rest_request
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

    def eloqua_bulk_request
      @eloqua_bulk_request ||= EloquaRequest.new(params[:site_id], params[:host], "/API/BULK/2.0")
    end

    def eloqua_cloud_request
      @eloqua_cloud_request ||= EloquaRequest.new(params[:site_id], params[:host], "/API/CLOUD/1.0")
    end

    def eloqua_rest_request
      @eloqua_rest_request ||= EloquaRequest.new(params[:site_id], params[:host], "/API/REST/1.0")
    end
end
