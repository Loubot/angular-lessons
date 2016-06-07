'use strict'

angular.module('lessons').controller('UserController', [
  '$scope'
  '$mdSidenav'
  ( $scope, $mdSidenav ) ->
    console.log "User Controller"
    $scope.openLeftMenu = ->
      $mdSidenav('left').toggle()
  
])