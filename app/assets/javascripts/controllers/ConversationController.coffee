'use strict'

angular.module('lessons').controller('ConversationController', [
  "$scope"
  "$state"
  "$rootScope"
  "$stateParams"
  "alertify"
  "COMMS"
  "USER"
  ( $scope, $state, $rootScope, $stateParams, alertify, COMMS, USER ) ->
    console.log "ConversationController"
    console.log $stateParams

    $scope.scrollevent = ( $e ) ->
      
      return

    USER.get_user().then( ( user ) ->
      if parseInt( $stateParams.id ) != parseInt( $rootScope.USER.id )
        alertify.error "You are not authorised to view this"
        $state.go "welcome"
        
      else

        COMMS.GET(
          "/conversation"
          teacher_email: $rootScope.USER.email
          
        ).then( ( resp ) ->
          console.log resp
          alertify.success "Got conversation"
          $scope.conversations = resp.data.conversations
          $scope.conversation = $scope.conversations[0]
        ).catch( ( err ) ->
          console.log err
          alertify.error "Failed to get conversation"
        )
    ).catch( ( err ) ->
      alertify.error "Failed to get user"
      $state.go "welcome"
      $rootScope.USER = null
    )

    $scope.select_conversation = ( email ) ->
      
      COMMS.GET(
        "/conversation"
        student_email: email
        selected_conversation: true
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Got conversation"
        $scope.conversation = resp.data.conversation
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to get conversation"
      )

])