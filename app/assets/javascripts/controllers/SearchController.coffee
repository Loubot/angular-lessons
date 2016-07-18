'use strict'

angular.module('lessons').controller( 'SearchController', [
  "$scope"
  "$rootScope"
  "$stateParams"
  "COMMS"
  ( $scope, $rootScope, $stateParams, COMMS ) ->
    console.log "SearchController"
    console.log $stateParams
])