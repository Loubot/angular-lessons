'use strict'

angular.module('lessons').controller( 'ViewTeacherController', [
  "$scope"
  "$rootScope"
  "$state"
  "$stateParams"
  "$filter"
  "COMMS"
  "alertify"
  "$mdDialog"
  ( $scope, $rootScope, $state, $stateParams, $filter, COMMS, alertify, $mdDialog ) ->
    console.log "ViewTeacherController"

    $scope.message = {}



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


        google.maps.event.addDomListener window, 'resize', ->

          
          $scope.map.setCenter(
            lat: $scope.teacher.location.latitude
            lng: $scope.teacher.location.longitude
          )

      google.maps.event.addListenerOnce $scope.map, 'idle', ->
        google.maps.event.trigger($scope.map, 'resize')

    
    
    COMMS.GET(
      "/teacher/#{ $stateParams.id }/show-teacher"
    ).then( ( resp ) ->
      console.log "got teacher info"
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

    user_listener = $rootScope.$watch "User", ->
      console.log "User changed"
      if $rootScope.User?
        
        $scope.message.name = "#{ $rootScope.User.first_name } #{ $rootScope.User.last_name }"

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
      $scope.conversation = {}
      $scope.conversation.user_id1 = $rootScope.User.id
      $scope.conversation.user_id2 = $scope.teacher.id
      $scope.conversation.user_email1 = $rootScope.User.email
      $scope.conversation.user_email2 = $scope.teacher.email
      $scope.conversation.user_name1 = $rootScope.User.get_full_name()
      $scope.conversation.user_name2 = "#{ $scope.teacher.first_name } #{ $scope.teacher.last_name }"

      COMMS.POST(
        "/conversation"
        conversation: $scope.conversation
        message: $scope.message
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


    

  
    
  

  ])
