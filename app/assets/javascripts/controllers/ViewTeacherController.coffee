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
    console.log $state
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

    
    USER.get_user().then( ( user ) ->
      COMMS.GET(
        "/teacher/#{ $stateParams.id }/show-teacher"
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Got teacher info"
        $scope.teacher = resp.data.teacher
        set_profile()
        create_map()
        create_fotorama()
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
        console.log $scope.index
        return
      ), 3000 )

    
])