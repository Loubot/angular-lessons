'use strict'

angular.module('lessons').controller('UserController', [
  '$scope'
  '$rootScope'
  'USER'
  'alertify'
  'COMMS'
  '$auth'
  '$interval'
  ( $scope, $rootScope, USER, alertify, COMMS, $auth, $interval ) ->
    console.log "User Controller"

    $scope.teacher = {}
    $scope.scrollevent = ( $e ) ->
      
      # animate_elems()
      # @scrollPos = document.body.scrollTop or document.documentElement.scrollTop or 0
      # $scope.$digest()
      return


    USER.get_user().then( ( user ) ->
      alertify.success "Got user"
      console.log $rootScope.USER

    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
    )
    

    $scope.slides = []
    $scope.index = 1

    $interval((->
      $scope.index = ++$scope.index 
      $scope.index = 1 if $scope.index == 5
      # console.log $scope.index
      return
    ), 3000 )
      
])
 