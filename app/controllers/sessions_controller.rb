class SessionsController < ApplicationController

  def create
    p session_params  
    respond_to do |format|
      msg = { :status => "ok", :message => "Success!" }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end

  private
    def session_params
      params.permit( :session )
    end
end
