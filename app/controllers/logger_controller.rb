class LoggerController < RailsClientLogger::RailsClientLoggersController
  

  def log
    logger.info "alrigt bout %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    logger.info  params
    render nothing: true
  end
end