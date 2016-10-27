class LoggerController < RailsClientLogger::RailsClientLoggersController
  
  require 'json'
  def log
    # logger.debug params
    
    # error = JSON.parse( params[:message] )

    logger.info params
    
    # if error[ 'data' ]['errors'].present?
    #   logger.info "There hereby follows an error message. Please take note"
    #   logger.info params
    # end
    render nothing: true
  end
end