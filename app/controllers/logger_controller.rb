class LoggerController < RailsClientLogger::RailsClientLoggersController
  
  require 'json'
  def log
    error = JSON.parse( params[:message] )
    pp error['data']
    if error[ 'data' ]['errors'].present?
      logger.info "There hereby follows an error message. Please take note"
      logger.info params
    end
    render nothing: true
  end
end