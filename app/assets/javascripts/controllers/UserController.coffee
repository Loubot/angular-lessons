'use strict'

angular.module('lessons').controller('UserController', [
  '$scope'
  '$mdSidenav'
  'alertify'
  'COMMS'
  '$auth'
  ( $scope, $mdSidenav, alertify, COMMS, $auth ) ->
    console.log "User Controller"
    alertify.success 'Hello'
    $scope.openLeftMenu = ->
      $mdSidenav('left').toggle()

    

    $scope.register_teacher = ->

      $auth.submitRegistration($scope.teacher)
        .then( (resp) ->
          # handle success response
          console.log resp
          alertrify.success "Registered successfully"
        )
        .catch( (resp) ->
          # handle error response
          console.log resp
          alertify.error resp.data.errors.full_messages
        )
      console.log $scope.teacher
      # COMMS.POST(
      #   '/api/auth'
      #   $scope.teacher
      # ).then ( ( res ) ->
      #   console.log res
      #   alertify.success "Teacher created"
      # ), ( err ) ->
      #   console.log err
      #   alertify.error err.errors.full_messages
])