'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  'USER'
  '$mdSidenav'
  'alertify'
  '$auth'
  ( $scope, $rootScope, USER, $mdSidenav, alertify, $auth ) ->
    console.log "NavController"
    $scope.teacher = {}
    $scope.auth_type = null

    USER.get_user().then( ( user ) ->
      alertify.success = "Got user"
      console.log $rootScope.USER

    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
    )
    $scope.openLeftMenu = ( auth_type ) -> # 0=login; 1= register
      
      if auth_type == 0
        console.log 'Login'
        $scope.auth_type = 0
      else
        console.log 'register'
        $scope.auth_type = 1
      $mdSidenav('left').toggle()

    $scope.$watch('demo.isOpen', ( isOpen ) ->
      console.log isOpen
    )

    $scope.register_teacher = ->
      console.log $scope.teacher
      $scope.teacher.is_teacher = true

      $auth.submitRegistration( $scope.teacher )
        .then( (resp) ->
          # handle success response
          console.log resp
          console.log $rootScope.USER
        )
        .catch( (resp) ->
          # handle error response
          console.log resp
          alertify.error resp.data.errors.full_messages
          
        )

    $scope.login = ->
      $auth.submitLogin( $scope.teacher )
        .then( (resp) ->
          # handle success response
          console.log resp
          console.log $rootScope.USER
        )
        .catch( (resp) ->
          # handle error response
          
        )
])