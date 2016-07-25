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
  ( $scope, $rootScope, $state, $stateParams, USER, $filter, COMMS, alertify ) ->
    console.log "ViewTeacherController"
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

    window.initMap = ->
      USER.get_user().then( ( user ) ->
        COMMS.GET(
          "/teacher/#{ $stateParams.id }/show-teacher"
        ).then( ( resp ) ->
          console.log resp
          $scope.teacher = resp.data.teacher
          set_profile()
          create_map()

         


        ).catch( ( err ) ->
          console.log err
          alertify.error err.data.errors.full_messages
        )
      )
      


    


    set_profile = ->
      for photo in $scope.teacher.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $scope.teacher.profile )
          # console.log photo
          $scope.profile = photo
          # console.log $scope.profile
          $scope.profile

    
])