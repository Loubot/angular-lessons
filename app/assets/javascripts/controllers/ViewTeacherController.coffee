'use strict'

angular.module('lessons').controller( 'ViewTeacherController', [
  "$scope"
  "$rootScope"
  "$state"
  "$stateParams"
  "USER"
  "$filter"
  "COMMS"
  "alertify"
  "$mdDialog"
  "$http"
  "$auth"
  ( $scope, $rootScope, $state, $stateParams, USER, $filter, COMMS, alertify, $mdDialog, $http, $auth ) ->
    console.log "ViewTeacherController"

    $scope.message = {}

    $scope.scrollevent = ( $e ) ->
      
      # animate_elems()
      # @scrollPos = document.body.scrollTop or document.documentElement.scrollTop or 0
      # $scope.$digest()
      return

    create_map = ->
      if $scope.teacher.location?

        $scope.map = new google.maps.Map(document.getElementById('map'), 
          center: 
            lat: $scope.teacher.location.latitude
            lng: $scope.teacher.location.longitude
          zoom: 15
          mapTypeId: google.maps.MapTypeId.ROADMAP
          
        )

        $scope.map.setOptions(
          clickableIcons: false
          disableDefaultUI: true
          disableDoubleClickZoom: true
          draggable: false
          scrollwheel: false
        )

        marker = new google.maps.Marker(
          position:
            lat: $scope.teacher.location.latitude
            lng: $scope.teacher.location.longitude
          map: $scope.map
          title: "#{ $scope.teacher.first_name } location"
        )

    
    
    COMMS.GET(
      "/teacher/#{ $stateParams.id }/show-teacher"
    ).then( ( resp ) ->
      console.log resp
      alertify.success "Got teacher info"
      $scope.teacher = resp.data.teacher
      set_profile()
      create_map() if $scope.teacher.location?
      create_fotorama()
    ).catch( ( err ) ->
      console.log err
      alertify.error err.data.errors.full_messages
      $state.go 'welcome'
    )
    
      


    


    set_profile = ->
      for photo in $scope.teacher.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $scope.teacher.profile )
          # console.log photo
          $scope.profile = photo
          # console.log $scope.profile
          $scope.profile


    #################### fotrama ########################################
    create_fotorama = ->
      $scope.slides = []
      for photo, index in $scope.teacher.photos
        $scope.slides.push(
          image: photo.avatar.url
          index: index + 1
          description: "Image #{ index + 1 }"
        )

      console.log $scope.slides
      $scope.index = 1

      id = setInterval((->
        if $state.$current.name != "view_teacher"
          clearInterval( id )
          return false
        $scope.index = ++$scope.index 
        $scope.index = 1 if $scope.index == $scope.teacher.photos.length + 1
        $scope.$apply()
        return
      ), 3000 )

    
    ####################### Message dialog #############################

    user_listener = $rootScope.$watch "USER", ->
      console.log "User changed"
      if $rootScope.USER?
        
        $scope.message.name = "#{ $rootScope.USER.first_name } #{ $rootScope.USER.last_name }"

    $scope.open_message_dialog = ->
      $mdDialog.show(
        clickOutsideToClose: true
        scope: $scope
        preserveScope: true
        templateUrl: "dialogs/message_teacher_dialog.html"
      )

    $scope.closeDialog = ->
      $mdDialog.hide()

    $scope.send_message = ->
      console.log $scope.message
      $scope.message.teacher_id = $scope.teacher.id
      $scope.message.teacher_email = $scope.teacher.email
      $scope.message.student_email = $rootScope.USER.email
      COMMS.POST(
        "/conversation"
        conversation: $scope.message
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Message sent!"
        $mdDialog.hide()
      ).catch( ( err ) ->
        console.log err
      )

    $scope.open_login_or_register = ->
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


    
    
    $auth.requestPasswordReset(email: "lllouis@yahoo.com").then((resp) ->
      console.log resp
      return
    ).catch (resp) ->
      console.log resp
      return
    

    $scope.$on 'auth:registration-email-success', (ev, message)->
      alert("A registration email was sent to " + message.email);


    # $scope.$on 'auth:password-reset-request-error', (ev, resp) ->
    #   alert 'Password reset request failed: ' + resp.errors[0]
      

    $scope.$on 'auth:password-reset-request-success', (ev, data) -> 
      alert("Password reset instructions were sent to " + data.email)

    $rootScope.$on 'auth:password-reset-confirm-success', -> 
      # $state.go('account.password-reset')
      alert "reset what?"


    $scope.update_password = ->

      $auth.updatePassword($scope.passwordResetForm).then((resp) ->
        console.log resp
        return
      ).catch (resp) ->
        console.log resp
        return
    
  

  ])
