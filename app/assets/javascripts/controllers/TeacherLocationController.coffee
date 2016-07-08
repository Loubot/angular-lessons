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

    $scope.map = { center: { latitude: 53.416185, longitude: -7.950045 }, zoom: 8 }
      
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