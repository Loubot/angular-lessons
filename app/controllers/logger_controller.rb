class LoggerController < RailsClientLogger::RailsClientLoggersController
  

  def log
    logger.debug "alrigt bout %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    logger.debug  params
    render nothing: true
  end
end