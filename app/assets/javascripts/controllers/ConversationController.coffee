'use strict'

angular.module('lessons').controller('ConversationController', [
  "$state"
  "$rootScope"
  "$stateParams"
  "alertify"
  "COMMS"
  "USER"
  ( $state, $rootScope, $stateParams, alertify, COMMS, USER ) ->
    console.log "ConversationController"
    console.log $stateParams
    USER.get_user().then(
      if parseInt( $stateParams.id ) != parseInt( USER.id )
        alertify.error "You are not authorised to view this"
        $state.go "welcome"
        
      else

        COMMS.GET(
          "/conversation"
          teacher_email: USER.email
        ).then( ( resp ) ->
          console.log resp
          alertify.success "Got conversation"
        ).catch( ( err ) ->
          console.log err
          alertify.error "Failed to get conversation"
        )
    ).catch( ( err ) ->
      alertify.error "Failed to get user"
      $state.go "welcome"
      $rootScope.USER = null
    )

])