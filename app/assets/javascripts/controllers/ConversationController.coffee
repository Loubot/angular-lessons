'use strict'

angular.module('lessons').controller('ConversationController', [
  "$scope"
  "$state"
  "$rootScope"
  "$stateParams"
  "alertify"
  "COMMS"
  "USER"
  "$timeout"
  ( $scope, $state, $rootScope, $stateParams, alertify, COMMS, USER, $timeout ) ->
    console.log "ConversationController"
    console.log $stateParams

    $scope.scrollevent = ( $e ) ->
      
      return

    fetch_conversations = ->
      COMMS.GET(
        "/conversation"
        random: $stateParams.random
        # conversation_id: $stateParams.id
        teacher_email: $rootScope.USER.email if $rootScope.USER?
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Got conversation"
        $scope.conversation =   resp.data.conversations[0]
        $scope.conversations =  resp.data.conversations if resp.data.conversations?
        $timeout (->
          $(".message_container").animate({ scrollTop: $(".message_container").height() }, "slow");
        ), 1500
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to get conversation"
      )
    

    USER.get_user().then( ( user ) ->
      alertify.success "Got user"
      fetch_conversations()

    ).catch( ( err ) ->
      alertify.error "Failed to get user"
      fetch_conversations()
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
        alertify.success "Message sent ok"
        $scope.conversation = resp.data.conversation
        $(".message_container").animate({ scrollTop: $(".message_container").height() }, "slow");
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to send message"
      )

])