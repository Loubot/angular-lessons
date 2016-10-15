class LoggerController < RailsClientLogger::RailsClientLoggersController
  
  require 'json'
  def log
    logger.info "There hereby follows an error message. Please take note"
    logger.info params
    render nothing: true
  end
end