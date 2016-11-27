'use strict'

angular.module('lessons').controller( "TeacherLocationController" , [
  '$scope'
  '$rootScope'
  '$state'
  '$stateParams'
  "COMMS"
  "USER"
  'alertify'
  '$mdBottomSheet' 
  '$mdToast'
  '$q'
  'counties'
  ( $scope, $rootScope, $state, $stateParams, COMMS, USER, alertify, $mdBottomSheet, $mdToast, $q, counties ) ->
    console.log "TeacherLocationController"
    $scope.addresses = null
    $scope.address = {}
    $scope.i_want_map = false
    only_once = false

    $scope.county_list = counties.county_list()


    $scope.i_want_map_toggle = ->     

      if !$scope.i_want_map && !only_once
        $scope.i_want_map = !$scope.i_want_map
        init_map() 
        only_once = true

    init_map = ->
      if $rootScope.User? && $rootScope.User.location

        $scope.map = new google.maps.Map(document.getElementById('map'), {
          center: 
            lat: $rootScope.User.location.latitude
            lng: $rootScope.User.location.longitude
          zoom: 15
          mapTypeId: google.maps.MapTypeId.ROADMAP
        })

        console.log 'yep'
        set_marker( $rootScope.User.location )
      else
        $scope.map = new google.maps.Map(document.getElementById('map'), {
          center: 
            lat: 53.416185
            lng: -7.950045
          zoom: 8
          mapTypeId: google.maps.MapTypeId.ROADMAP
        })
        alertify.log "Use the search box to find your location"
        alertify.log "Just enter your county if you don't want to enter your address"

      

      $scope.map.addListener( 'click', ( position ) ->
        console.log position.latLng.lat()
        console.log position.latLng.lng()
        geocoder.geocode( 'location': { lat: position.latLng.lat(), lng: position.latLng.lng() }, ( results, status ) ->

          console.log results
          console.log status
          $scope.addresses = results
          $scope.$apply()

          $mdToast.showSimple "Select your address from the list by checking the box next to it"
          $mdToast.showSimple """If you don't see your address then click "Enter manually" and type it in yourself """
          # alertify.logPosition("top left")
          # alertify.log("Select your address from the list by checking the box next to it")
          # alertify.log("""If you don't see your address then click "Enter manually" and type it in yourself """)

        )
      )

      input = document.getElementById('pac-input')
      $scope.searchBox = new google.maps.places.SearchBox(input)
      $scope.map.controls[google.maps.ControlPosition.TOP_LEFT].push(input)
      geocoder = new google.maps.Geocoder
      $scope.searchBox.addListener('places_changed', ->
        places = $scope.searchBox.getPlaces()
        console.log places
        $scope.map.setCenter(
          lat: places[0].geometry.location.lat()
          lng: places[0].geometry.location.lng()
        )
        $scope.map.setZoom( 15 )
        $mdToast.showSimple "Click on the map to locate your address"
        # alertify.log("Click on the map to locate your address")
      )

    set_marker = ( location ) ->
      $scope.marker.setMap null if $scope.marker?

      $scope.marker = new google.maps.Marker
        position: 
          lat:    location.latitude
          lng:    location.longitude
        title:    location.name
        map:      $scope.map

      $('#pac-input').val ''
    
    
    USER.get_user().then( ( user ) ->
      if $rootScope.USER.location?
        $scope.address = $rootScope.USER.location
        $scope.address.county = $rootScope.USER.location.name if !$rootScope.USER.location.county?
      else
        $mdToast.showSimple "Your profile might not be visible if you don't enter a location. Your county will do fine" 
        
      USER.check_user()
      init_map() if $scope.i_want_map

      

    ).catch( ( err ) ->
      console.log err
      alertify.error "You are not authorised to view this"
      $state.go 'welcome'
    )

       

      

    ################################# Address update ############################################################

    $scope.updateSelection = (position, addresses) ->
      $scope.selected_address = addresses[position] #this is the address tha user wants to save. Uploaded in update_address
      console.log addresses[position]
      $mdToast.showSimple("Click Update address to save this address");
      angular.forEach addresses, (address, index) ->
        if position != index
          address.checked = false

    $scope.update_address = ->
      $scope.selected_address.county = $rootScope.User.location.county
      

      $rootScope.User.manual_address( ( $scope.selected_address )
      ).then( ( resp ) ->
        
        $scope.marker.setMap null if $scope.marker?

        set_marker( $rootScope.User.location )

        $('#pac-input').val ''
        $scope.addresses = null
      ).catch( ( err ) ->
        console.log err
        alertify.error err.data.error[0]
      )

    $scope.address_form_submit = ->
      $rootScope.User.update_address( $scope.address )

    

    $scope.manual_address = ->
      console.log $scope.addresses
      merged_address = 
        teacher_id: "#{$rootScope.USER.id}"
        longitude:  $scope.addresses[0].geometry.location.lng()
        latitude:   $scope.addresses[0].geometry.location.lat()
        name:       "#{ $rootScope.USER.first_name } address"
        address:    $scope.address
        county:     $rootScope.User.location.county

      $rootScope.User.update_address( merged_address, $scope.i_want_map )

    ################## Delete location ########################
    $scope.delete_location = ->
      $rootScope.User.delete_location()

    ################## End of delete location ################

    ######### open location_sheet ########################
    $scope.open_location_sheet = ->
      console.log 'location sheet'
      $mdBottomSheet.show(
        scope: $scope
        preserveScope: true
        templateUrl: "sheets/location_sheet.html"
      ).then( ( clicked ) ->
        console.log clicked
        $mdToast.simple ""
      )

       
])