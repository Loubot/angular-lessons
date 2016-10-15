class LoggerController < RailsClientLogger::RailsClientLoggersController
  
  require 'json'
  def log 
    logger.info params
    render nothing: true
  end
end