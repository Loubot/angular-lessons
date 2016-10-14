class LoggerController < RailsClientLogger::RailsClientLoggersController
  
  require 'json'
  def log 
    
    # logger.fatal params
    error = JSON.parse params['message']

    if error['data']['errors'][0] != "Authorized users only."
      logger.info "There hereby follows an error message. Please take note."
      logger.fatal params

    end

    render nothing: true
  end
end