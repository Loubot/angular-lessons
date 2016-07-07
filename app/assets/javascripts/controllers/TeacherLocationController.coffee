'use strict'

angular.module('lessons').controller( "TeacherLocationController" , [
  '$scope'
  '$rootScope'
  '$state'
  '$stateParams'
  "COMMS"
  "USER"
  "NgMap"

  ( $scope, $rootScope, $state, $stateParams, COMMS, USER, NgMap ) ->
    console.log "TeacherLocationController"

    window.initMap = ->
      
])