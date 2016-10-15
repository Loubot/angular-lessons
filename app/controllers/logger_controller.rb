class LoggerController < RailsClientLogger::RailsClientLoggersController
  
  require 'json'
  def log 
    logger.info params
   
  end
end