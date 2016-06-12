'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  '$mdSidenav'
  ( $scope, $rootScope, $mdSidenav ) ->
    console.log "NavController"
    $scope.openLeftMenu = ->

      $mdSidenav('left').toggle()

    $scope.$watch('demo.isOpen', ( isOpen ) ->
      console.log isOpen
    )
])