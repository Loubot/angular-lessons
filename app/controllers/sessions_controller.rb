class SessionsController < ApplicationController

  def create
    p params
    respond_to do |format|
      msg = { :status => "ok", :message => "Success!" }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end
end
