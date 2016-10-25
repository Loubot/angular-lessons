class LoggerController < RailsClientLogger::RailsClientLoggersController
  
  require 'json'
  def log
    logger.info params
    # pp error['data']
    # error = JSON.parse( params[:message] )
    
    # if error[ 'data' ]['errors'].present?
    #   logger.info "There hereby follows an error message. Please take note"
    #   logger.info params
    # end
    render nothing: true
  end
end