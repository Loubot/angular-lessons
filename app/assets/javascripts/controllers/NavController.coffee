'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  '$state'
  'USER'
  '$mdSidenav'
  'alertify'
  '$auth'
  ( $scope, $rootScope, $state, USER, $mdSidenav, alertify, $auth ) ->
    console.log "NavController"
    $scope.teacher = {}
    $scope.auth_type = null

    # USER.get_user().then( ( user ) ->
    #   # alertify.success "Got user"
    #   # console.log $rootScope.USER

    # ).catch( ( err ) ->
    #   alertify.error "No user"
    #   $rootScope.USER = null
    # )
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

    $scope.openRightMenu = ->
      console.log "yep"
      $mdSidenav('right').toggle()

    $scope.register_teacher = ->
      console.log $scope.teacher
      $scope.teacher.is_teacher = true

      $auth.submitRegistration( $scope.teacher )
        .then( (resp) ->
          # handle success response
          console.log resp.data.data
          $mdSidenav('left').toggle()
          console.log $rootScope.USER
          $rootScope.USER = resp.data.data
          alertify.success "Welcome #{ resp.data.data.email }"
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
          $rootScope.USER = resp
          console.log resp
          
          $mdSidenav('left').toggle()
          alertify.success "Welcome back #{ $rootScope.USER.name }"
        )
        .catch( (resp) ->
          # handle error response
          
        )

    $scope.logout = ->
      $auth.signOut()
        .then( ( resp ) ->
          console.log resp
          alertify.success "Logged out successfully"
          $rootScope.USER = null
          $state.go 'welcome'
        ).catch( ( err ) ->
          console.log err
          $rootScope.USER = null
          alertify.error "Failed to log out"
        )
])