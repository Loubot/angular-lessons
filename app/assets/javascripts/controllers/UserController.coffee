'use strict'

angular.module('lessons').controller('UserController', [
  '$scope'
  '$rootScope'
  'USER'
  '$mdSidenav'
  'alertify'
  'COMMS'
  'AUTH'
  '$http'
  ( $scope, $rootScope, USER, $mdSidenav, alertify, COMMS, AUTH, $http ) ->
    console.log "User Controller"
    

    USER.get_user().then( ( user ) ->
      alertify.success = "Got user"
      console.log $rootScope.USER

    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
    )
    $scope.openLeftMenu = ->
      $mdSidenav('left').toggle()

    

    $scope.register_teacher = ->
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
      
      
])

$('.welcome_fotorama').fotorama
  # width: "100%"
  # height: "100%"
  transition: "crossfade"
  loop: true
  autoplay: false
  nav: false
  allowfullscreen: true
  
  arrows: true     