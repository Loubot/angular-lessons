'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  'USER'
  '$mdSidenav'
  'alertify'
  ( $scope, $rootScope, USER, $mdSidenav, alertify ) ->
    console.log "NavController"
    $scope.logging_in = false

    USER.get_user().then( ( user ) ->
      alertify.success = "Got user"
      console.log $rootScope.USER

    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
    )
    $scope.openLeftMenu = ( request_type ) -> # 0=login; 1= register
      console.log request_type
      $mdSidenav('left').toggle()

    $scope.$watch('demo.isOpen', ( isOpen ) ->
      console.log isOpen
    )
])