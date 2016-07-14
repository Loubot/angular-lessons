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
  ( $scope, $rootScope, $state, $stateParams, COMMS, USER, uiGmapGoogleMapApi, uiGmapIsReady ) ->
    console.log "TeacherLocationController"

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
       
])