'use strict'

angular.module('lessons').controller( "TeacherLocationController" , [
  '$scope'
  '$rootScope'
  '$state'
  '$stateParams'
  "COMMS"
  "USER"
  "uiGmapGoogleMapApi"
  "uiGmapIsReady"
  'alertify'
  '$mdBottomSheet' 
  '$mdToast'
  ( $scope, $rootScope, $state, $stateParams, COMMS, USER, uiGmapGoogleMapApi, uiGmapIsReady, alertify, $mdBottomSheet, $mdToast ) ->
    console.log "TeacherLocationController"
    $scope.addresses = null

    USER.get_user().then( ( resp ) ->
      $rootScope.USER = resp
    )

    $scope.map = 
      center: 
        latitude: 53.416185, longitude: -7.950045
      zoom: 8
      markers: []

      events:
        click: ( map, eventName, originalEventArgs ) ->
          e = originalEventArgs[0]
          lat = e.latLng.lat()
          lon = e.latLng.lng()
          marker = 
            id: Date.now()
            coords: 
              latitude: lat
              longitude: lon
          $scope.map.markers = []
          $scope.map.markers.push marker
          console.log $scope.map.markers
          $scope.$apply()
          geocoder = new google.maps.Geocoder
          geocoder.geocode( 'location': { lat: e.latLng.lat(), lng: e.latLng.lng() }, ( results, status ) ->
            if results[1]
              console.log results
              $scope.addresses = results
              console.log status
              $scope.$apply()
          )


    $scope.searchbox = 
      template: 'map/search_template.html'
      events: places_changed: (searchBox) ->
        loc = searchBox.getPlaces()[0].geometry.location
        # console.log loc.lat()
        $scope.map.center.latitude = loc.lat()
        $scope.map.center.longitude = loc.lng()
        $scope.map.zoom = 15
        # console.log loc
    uiGmapGoogleMapApi.then( ( maps ) ->
      console.log maps
    )

    uiGmapIsReady.promise(1).then( ( insts ) ->
      for inst in insts
        map = inst.map
        uuid = map.uiGmap_id
        mapInstanceNumber = inst.instance # Starts at 1.
      console.log map


        
    )

    ################################# Address update ############################################################

    $scope.updateSelection = (position, addresses) ->
      $scope.selected_address = addresses[position] #this is the address tha user wants to save. Uploaded in update_address
      console.log addresses[position]
      angular.forEach addresses, (address, index) ->
        if position != index
          address.checked = false

    $scope.update_address = ->

      console.log "Update address"
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/location"
        format_address( $scope.selected_address )
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Location updated"
      ).catch( ( err ) ->
        console.log err
        alertify.error err.data.error[0]
      )

    format_address = ( google_address ) ->

      address =
        teacher_id: "#{$rootScope.USER.id}"
        longitude:  google_address.geometry.location.lng()
        latitude:   google_address.geometry.location.lat()
        name:       "#{ $rootScope.USER.first_name } address"
        address:    google_address.formatted_address

    $scope.manual_address = ->
      console.log $scope.addresses
      merged_address = 
        teacher_id: "#{$rootScope.USER.id}"
        longitude:  $scope.addresses[0].geometry.location.lng()
        latitude:   $scope.addresses[0].geometry.location.lat()
        name:       "#{ $rootScope.USER.first_name } address"
        address:    $scope.address

      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/location"
        merged_address
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Location updated ok"
        $mdBottomSheet.hide()
      ).catch( ( err ) ->
        console.log err
        alertify.error err.errors.full_messages
      )

    ######### open location_sheet ########################
    $scope.open_location_sheet = ->
      console.log 'location sheet'
      $mdBottomSheet.show(
        scope: $scope
        preserveScope: true
        templateUrl: "sheets/location_sheet.html"
        clickOutsideToClose: false
      ).then( ( clicked ) ->
        console.log clicked
        $mdToast.simple()
      )


    ######### end of open location_sheet#################

    ###############################end of address update ########################################################
       
])