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
  "$mdDialog"
  ( $scope, $state, $rootScope, $stateParams, alertify, COMMS, USER, $timeout , $mdDialog) ->
    console.log "ConversationController"
    console.log $stateParams
    $scope.show_form = false

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
        
        $scope.conversation = resp.data.conversation if resp.data.conversation?
        $scope.conversation =   resp.data.conversations[0] if ( resp.data.conversations? > 0  && resp.data.conversations.length > 0 )
        $scope.conversations =  resp.data.conversations if resp.data.conversations?

        if $scope.conversation?
          alertify.success "Got conversation"
        else
          alertify.error "Failed to find messages"
        scroll_to_bottom()
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

    $scope.update_user_email = ->
      if $scope.conversation?
        if $scope.user_email == $scope.conversation.teacher_email
          console.log 'bl'
    
    $scope.select_conversation = ( email ) ->
      
      COMMS.GET(
        "/conversation"
        student_email: email
        teacher_email: $rootScope.USER.email
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Got conversation"
        $scope.conversation = resp.data.conversation
        scroll_to_bottom()
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
        $scope.message.message = ""
        $('.message_text_area').text ""
        scroll_to_bottom()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to send message"
      )

    scroll_to_bottom = ->
      $timeout (->
        $(".message_container").animate({ scrollTop: $(".message_container").css "height" }, "slow");
      ), 1500

    # $scope.open_login_or_register = ->
    $mdDialog.show(
      templateUrl: "dialogs/login_or_register_dialog.html"
      scope: $scope
      openFrom: "left"
      closeTo: "right"
      preserveScope: true
      clickOutsideToClose: false
    )

    $scope.close_login_or_register = ->
      $mdDialog.hide()
])