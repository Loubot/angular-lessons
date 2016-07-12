'use strict'

angular.module('lessons').controller( "TeacherLocationController" , [
  '$scope'
  '$rootScope'
  '$state'
  '$stateParams'
  "COMMS"
  "USER"
  "usSpinnerService"
  "uiGmapGoogleMapApi"
  "uiGmapIsReady"
  ( $scope, $rootScope, $state, $stateParams, COMMS, USER, usSpinnerService, uiGmapGoogleMapApi, uiGmapIsReady ) ->
    console.log "TeacherLocationController"
    usSpinnerService.spin('spinner-1')

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


    $scope.searchbox = 
      template: 'search_template.html'
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

      google.maps.event.addListener( map, 'click', ( e ) ->
        # console.log "#{ e.latLng.lat() } #{ e.latLng.lng() }"
        # $scope.map.markers = []
        # marker = 
        #   id: Date.now()
        #   coords:
        #     latitude: e.latLng.lat()
        #     longitude: e.latLng.lng()

        # $scope.map.markers.push marker
        # console.log $scope.markers
        # $scope.$apply()
      )



      usSpinnerService.stop('spinner-1')
        
    )
       
])