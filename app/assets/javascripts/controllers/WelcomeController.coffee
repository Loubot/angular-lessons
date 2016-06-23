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


    COMMS.GET(
      "/subjects"
      $scope.subject
    ).then( ( resp ) ->
      console.log resp
      $scope.subjects = resp.data
      alertify.success "Got a subject"
    ).catch( ( err ) ->
      console.log err
      alertify.error "Failed to get subjects "
    )

    $scope.search = ->
      console.log $scope.selected_subject.name
])