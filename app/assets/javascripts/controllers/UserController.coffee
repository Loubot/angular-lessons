'use strict'

angular.module('lessons').controller('UserController', [
  '$scope'
  '$rootScope'
  'USER'
  'alertify'
  'COMMS'
  '$auth'
  '$http'
  '$interval'
  ( $scope, $rootScope, USER, alertify, COMMS, $auth, $http, $interval ) ->
    console.log "User Controller"

    $scope.teacher = {}
    

    USER.get_user().then( ( user ) ->
      alertify.success = "Got user"
      console.log $rootScope.USER

    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
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
 