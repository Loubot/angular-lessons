'use strict'

angular.module('lessons').controller('UserController', [
  '$scope'
  '$rootScope'
  'USER'
  'alertify'
  'COMMS'
  'AUTH'
  '$http'
  '$interval'
  ( $scope, $rootScope, USER, alertify, COMMS, AUTH, $http, $interval ) ->
    console.log "User Controller"

    $scope.teacher = {}
    

    USER.get_user().then( ( user ) ->
      alertify.success = "Got user"
      console.log $rootScope.USER

    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
    )
    

    

    $scope.register_teacher = ->
      console.log $scope.teacher
      $scope.teacher.is_teacher = true

      AUTH.signup( $scope.teacher )
        .then( (resp) ->
          # handle success response
          console.log resp
          console.log $rootScope.USER
        )
        .catch( (resp) ->
          # handle error response
          
        )
      
    $scope.slides = []
    $scope.index = 1

    $interval((->
      $scope.index = ++$scope.index 
      $scope.index = 1 if $scope.index == 4
      console.log $scope.index
      return
    ), 3000 )
      
])
 