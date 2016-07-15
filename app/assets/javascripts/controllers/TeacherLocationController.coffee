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
  ( $scope, $rootScope, $state, $stateParams, COMMS, USER, alertify, $mdBottomSheet, $mdToast, $q ) ->
    console.log "TeacherLocationController"
    $scope.addresses = null

    window.initMap = ->
      $scope.map = new google.maps.Map(document.getElementById('map'), {
        center: 
          lat: 53.416185
          lng: -7.950045
        zoom: 8
      })

      $scope.map.addListener( 'click', ( position ) ->
        console.log position.latLng.lat()
        console.log position.latLng.lng()
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
        $rootScope.associations.location = resp.data.location
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
        $rootScope.associations.location = resp.data.location
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