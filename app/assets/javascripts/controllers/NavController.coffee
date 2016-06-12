'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  'USER'
  '$mdSidenav'
  'alertify'
  ( $scope, $rootScope, USER, $mdSidenav, alertify ) ->
    console.log "NavController"

    USER.get_user().then( ( user ) ->
      alertify.success = "Got user"
      console.log $rootScope.USER

    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
    )
    $scope.openLeftMenu = ->
      console.log 'yep'
      $mdSidenav('left').toggle()

    $scope.$watch('demo.isOpen', ( isOpen ) ->
      console.log isOpen
    )
])