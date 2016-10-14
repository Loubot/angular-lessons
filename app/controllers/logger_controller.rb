class LoggerController < RailsClientLogger::RailsClientLoggersController
  
  require 'json'
  def log 
    
    begin 
      error = JSON.parse params['message']

      if error['data']['errors'][0] != "Authorized users only."
        logger.info "There hereby follows an error message. Please take note."
        logger.fatal params

      end
    rescue NoMethodError

      # render nothing: true
    ensure
      render nothing: true
    end
  end
end