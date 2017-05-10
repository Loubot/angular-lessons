'use strict'

angular.module('lessons').controller('ConversationController', [
  "$scope"
  "$state"
  "$rootScope"
  "$stateParams"
  "$mdSidenav"
  "Alertify"
  "COMMS"
  "$timeout"
  "$mdDialog"
  ( $scope, $state, $rootScope, $stateParams, $mdSidenav, Alertify, COMMS, $timeout , $mdDialog) ->
    console.log "ConversationController"
    $scope.show_form = false
    console.log $stateParams.id
    

    $scope.search_conversations = ->
      $mdSidenav('conversation_search').toggle()

    
    get_conversations = ->
      COMMS.GET(
        "/conversation"
      ).then( ( resp ) ->
        console.log resp
        
        $scope.conversations = resp.data.conversations
        if $scope.conversations?
          Alertify.success "Got conversations"
        else
          Alertify.error "Failed to find conversations"
        scroll_to_bottom()
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to get conversation"
      )

    get_conversations()
    $rootScope.$on "new:message", ->
      get_conversations()

    
    $scope.select_conversation = ( id, dom_element ) ->

      $( dom_element.target ).find('md-icon').remove() if dom_element? and dom_element.target? and $( dom_element.target ).find('md-icon')?

      COMMS.GET(
        "/conversation/#{ id }"
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Got conversation"
        $scope.conversation = resp.data.conversation
        scroll_to_bottom()
        $mdSidenav('conversation_search').close()
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to get conversation"
        $mdSidenav('conversation_search').close()
      )

      return true

    $scope.select_conversation( $stateParams.id ) if $stateParams.id #fetch specific conversation if id is present. i.e. from email link


    $scope.send_message = ( message )  ->
      
      if !$rootScope.User?
        Alertify.logPosition("bottom left")
        Alertify.log("You must be registered to respond")
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
          Alertify.success "Email sent ok"
          $scope.conversation = resp.data.conversation
          $('.message_text_area').val ""
          scroll_to_bottom()
        ).catch( ( err ) ->
          console.log err
          Alertify.error "Failed to send message"
        )

    scroll_to_bottom = ->
      $timeout (->
        height = document.getElementById("message_container").scrollHeight
        $("#message_container").animate({ scrollTop: height }, "slow");
      ), 2000

    open_login_or_register = ->
      $mdDialog.show(
        templateUrl: "dialogs/login.html"
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