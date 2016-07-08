'use strict'

angular.module('lessons').controller( "TeacherLocationController" , [
  '$scope'
  '$rootScope'
  '$state'
  '$stateParams'
  "COMMS"
  "USER"
 

  ( $scope, $rootScope, $state, $stateParams, COMMS, USER ) ->
    console.log "TeacherLocationController"

    $scope.map = { center: { latitude: 45, longitude: -73 }, zoom: 8 }
      

])