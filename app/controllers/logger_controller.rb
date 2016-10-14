class LoggerController < RailsClientLogger::RailsClientLoggersController
  

  def log 
    logger.info "There hereby follows an error message. Please take note."
    logger.fatal "Level: #{ params[:level] }, Message: #{ params[:message] }"
    render nothing: true
  end
end