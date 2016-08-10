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
      console.log $rootScope.USER.email if $rootScope.USER?
      if $rootScope.USER?
        COMMS.GET(
          "/conversation"
          {
            random: $stateParams.random if $stateParams.random? && $stateParams.random != ""
            # conversation_id: $stateParams.id
            teacher_email: $rootScope.USER.email if $rootScope.USER?
          }
        ).then( ( resp ) ->
          console.log resp
          
          $scope.conversation = resp.data.conversation if resp.data.conversation?
          $scope.conversation =   resp.data.conversations[0] if ( resp.data.conversations? && resp.data.conversations.length > 0 )
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
    
    $rootScope.$watch "USER", ->
      console.log "Changed"
      fetch_conversations()

    USER.get_user().then( ( user ) ->
      alertify.success "Got user"
      

    ).catch( ( err ) ->
      alertify.error "Failed to get user"
      open_login_or_register()
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
        scroll_to_bottom()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to get conversation"
      )

    $scope.send_message = ->
      if !$rootScope.USER?
        alertify.logPosition("bottom left")
        alertify.log("You must be registered to respond")
        open_login_or_register()
      else
        $scope.message.teacher_email = $scope.conversation.teacher_email
        $scope.message.student_email = $scope.conversation.student_email
        $scope.message.sender_email = $rootScope.USER.email
        $scope.message.name = "#{ $rootScope.USER.first_name } #{ $rootScope.USER.last_name }"
        # $scope.message.name = $scope.conversation.student_name
        COMMS.POST(
          "/conversation"
          conversation: $scope.message
        ).then( ( resp ) ->
          console.log resp
          alertify.success "Email sent ok"
          $scope.conversation = resp.data.conversation
          $scope.message.message = ""
          scroll_to_bottom()
        ).catch( ( err ) ->
          console.log err
          alertify.error "Failed to send message"
        )

    scroll_to_bottom = ->
      $timeout (->
        $(".message_container").animate({ scrollTop: $(".message_container").css "height" }, "slow");
      ), 1500

    open_login_or_register = ->
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

    

    $scope.choose_credentials = ( index ) ->
      openLeftMenu( index )
      $mdDialog.hide()
      
])