'use strict'

angular.module('lessons').controller('ConversationController', [
  "$scope"
  "$state"
  "$rootScope"
  "$stateParams"
  "$mdSidenav"
  "alertify"
  "COMMS"
  "USER"
  "$timeout"
  "$mdDialog"
  ( $scope, $state, $rootScope, $stateParams, $mdSidenav, alertify, COMMS, USER, $timeout , $mdDialog) ->
    console.log "ConversationController"
    console.log $stateParams
    $scope.show_form = false

    $scope.search_conversations = ->
      $mdSidenav('conversation_search').toggle()

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
            teacher_email: $rootScope.USER.email if $rootScope.USER? && $rootScope.USER.is_teacher
            student_email: $rootScope.USER.email if $rootScope.USER? && !$rootScope.USER.is_teacher
          }
        ).then( ( resp ) ->
          console.log resp
          
          $scope.conversation = resp.data.conversation if resp.data.conversation?
          $scope.conversation =   resp.data.conversations[0] if ( resp.data.conversations? && resp.data.conversations.length > 0 )
          $scope.conversations =  resp.data.conversations if resp.data.conversations?

          if $scope.conversation?
            alertify.success "Got conversations"
          else
            alertify.error "Failed to find conversations"
          scroll_to_bottom()
        ).catch( ( err ) ->
          console.log err
          alertify.error "Failed to get conversation"
        )
    
    # user_listener = $rootScope.$watch "USER", (newValue, oldValue) ->
    #   console.log newValue
    #   console.log oldValue
    #   console.log "Changed"
    #   if $state.current.name == "conversation"
        # fetch_conversations()



    USER.get_user().then( ( user ) ->
      alertify.success "Got user"
      fetch_conversations()

    ).catch( ( err ) ->
      alertify.error "Failed to get user"
      open_login_or_register()
    )

    
    $scope.select_conversation = ( id ) ->
      
      COMMS.GET(
        "/conversation"
        conversation_id: id
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
        height = document.getElementById("message_container").scrollHeight
        $(".message_container").animate({ scrollTop: height }, "slow");
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
      $state.go('teacher_area', student_email: $scope.conversation.student_email, id: $rootScope.USER.id )
      user_listener() #clear watch on USER
      
])