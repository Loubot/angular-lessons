'use strict'

angular.module('lessons').controller('WelcomeController', [
  '$scope'
  '$rootScope'
  'USER'
  '$mdSidenav'
  'alertify'
  '$auth'
  'COMMS'
  ( $scope, $rootScope, USER, $mdSidenav, alertify, $auth, COMMS ) ->
    console.log "WelcomeController"
    $scope.subject = new Object

    $scope.search = ->
      COMMS.GET(
        "/subjects"
        $scope.subject
      ).then( ( subjects ) ->
        console.log subjects
        alertify.success "Got a subject"
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to get subjects "
      )
])