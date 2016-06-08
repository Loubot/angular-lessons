'use strict'

angular.module('lessons').controller('UserController', [
  '$scope'
  '$mdSidenav'
  'alertify'
  'COMMS'
  ( $scope, $mdSidenav, alertify, COMMS ) ->
    console.log "User Controller"
    alertify.success 'Hello'
    $scope.openLeftMenu = ->
      $mdSidenav('left').toggle()

    $scope.register_teacher = ->
      console.log $scope.teacher
      COMMS.POST(
        '/api/auth'
        $scope.teacher
      ).then ( ( res ) ->
        console.log res
        alertify.success "Teacher created"
      ), ( err ) ->
        console.log err
        alertify.error "Couldn't register"
])