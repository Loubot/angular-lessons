'use strict'

angular.module('lessons').controller('UserController', [
  '$scope'
  '$mdSidenav'
  'COMMS'
  ( $scope, $mdSidenav, COMMS ) ->
    console.log "User Controller"
    $scope.openLeftMenu = ->
      $mdSidenav('left').toggle()

    $scope.register_teacher = ->
      console.log $scope.teacher
      COMMS.POST(
        '/auth/sign_in'
        $scope.teacher
      ).then ( ( res ) ->
        console.log res
      ), ( err ) ->
        console.log err
])