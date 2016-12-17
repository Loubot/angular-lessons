'use strict'

angular.module('lessons').controller('ConversationController', [
  "$scope"
  "$state"
  "$rootScope"
  "$stateParams"
  "$mdSidenav"
  "alertify"
  "COMMS"
  "$timeout"
  "$mdDialog"
  ( $scope, $state, $rootScope, $stateParams, $mdSidenav, alertify, COMMS, $timeout , $mdDialog) ->
    console.log "ConversationController"
    $scope.show_form = false

    $scope.search_conversations = ->
      $mdSidenav('conversation_search').toggle()

    
    COMMS.GET(
      "/conversation"
    ).then( ( resp ) ->
      console.log resp
      
      $scope.conversations = resp.data.conversations
      $scope.conversation = resp.data.conversations[0] if $scope.conversations?

      if $scope.conversation?
        alertify.success "Got conversations"
      else
        alertify.error "Failed to find conversations"
      scroll_to_bottom()
    ).catch( ( err ) ->
      console.log err
      alertify.error "Failed to get conversation"
    )

    
    $scope.select_conversation = ( id ) ->
      COMMS.GET(
        "/conversation/#{ id }"
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Got conversation"
        $scope.conversation = resp.data.conversation
        scroll_to_bottom()
        $scope.search_conversations()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to get conversation"
        $scope.search_conversations()
      )



    $scope.send_message = ( message )  ->
      
      if !$rootScope.User?
        alertify.logPosition("bottom left")
        alertify.log("You must be registered to respond")
        open_login_or_register()
      else
        message.sender_id = $rootScope.User.id
        message.conversation_id = $scope.conversation.id
        COMMS.POST(
          "/conversation"
          conversation: $scope.conversation
          message: message
        ).then( ( resp ) ->
          console.log resp
          alertify.success "Email sent ok"
          $scope.conversation = resp.data.conversation
          $('.message_text_area').val ""
          scroll_to_bottom()
        ).catch( ( err ) ->
          console.log err
          alertify.error "Failed to send message"
        )

    scroll_to_bottom = ->
      $timeout (->
        console.log "scroll it"
        height = document.getElementById("message_container").scrollHeight
        $("#message_container").animate({ scrollTop: height }, "slow");
      ), 2000

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

    ########################### Create event ######################################
    $scope.create_event = ->
      $state.go('teacher_area', student_email: $scope.conversation.student_email, id: $rootScope.User.id )
      user_listener() #clear watch on USER
      
])