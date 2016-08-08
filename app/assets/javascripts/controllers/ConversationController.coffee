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

    if $stateParams.id?

      USER.get_user().then( ( user ) ->
        alertify.success "Got user"
        COMMS.GET(
          "/conversation"
          random: $stateParams.random
          # conversation_id: $stateParams.id
          teacher_email: $rootScope.USER.email
        ).then( ( resp ) ->
          console.log resp
          alertify.success "Got conversation"
          $scope.conversation =   resp.data.conversation
          $scope.conversations =  resp.data.conversations if resp.data.conversations?
        ).catch( ( err ) ->
          console.log err
          alertify.error "Failed to get conversation"
        )

      ).catch( ( err ) ->
        alertify.error "Failed to get user"
      )

    
    $scope.select_conversation = ( email ) ->
      
      COMMS.GET(
        "/conversation"
        student_email: email
        teacher_email: $rootScope.USER.email
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Got conversation"
        $scope.conversation = resp.data.conversation
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to get conversation"
      )

    $scope.send_message = ->
      $scope.message.teacher_email = $scope.conversation.teacher_email
      $scope.message.student_email = $scope.conversation.student_email
      $scope.message.name = $scope.conversation.student_name
      COMMS.POST(
        "/conversation"
        conversation: $scope.message
      ).then( ( resp ) ->
        console.log resp
      ).catch( ( err ) ->
        console.log err
      )

])