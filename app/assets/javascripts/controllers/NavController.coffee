'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  '$state'
  '$window'
  'USER'
  '$mdSidenav'
  'alertify'
  '$auth'
  ( $scope, $rootScope, $state, $window, USER, $mdSidenav, alertify, $auth ) ->
    console.log "NavController"
    $scope.teacher = {}
    $scope.auth_type = null

    $scope.facebook = ->
      console.log 'facebook'
      $auth.authenticate('facebook', {params: {resource_class: 'Teacher'}})
      # $auth.authenticate('facebook')

    $scope.user_menu = ->
      $mdSidenav('user_menu').toggle()
      
    $scope.openLeftMenu = ( auth_type ) -> # 0=login; 1= register
      
      if auth_type == 0
        console.log 'Login'
        $scope.auth_type = 0
      else if auth_type == 2
        console.log "register student"
        $scope.auth_type == 2
      else
        console.log 'register teacher'
        $scope.auth_type = 1
      $mdSidenav('left').toggle()

    # $scope.$watch('demo.isOpen', ( isOpen ) ->
    #   console.log isOpen
    # )

    $scope.openRightMenu = ->
      console.log "yep"
      $mdSidenav('right').toggle()

    $scope.closeRightMenu = ->
      $mdSidenav('right').toggle()

    $scope.register_teacher = ->
      console.log $scope.teacher
      $scope.teacher.is_teacher = true if $scope.auth_type == 1

      $auth.submitRegistration( $scope.teacher )
        .then( (resp) ->
          # handle success response
          # console.log resp.data.data
          $mdSidenav('left').toggle()
          $rootScope.USER = resp.data.data
          console.log $rootScope.USER
          
          alertify.success "Welcome #{ resp.data.data.email }"
        )
        .catch( (resp) ->
          # handle error response
          console.log resp
          alertify.error "Failed to register"
          
        )

    $scope.login = ->
      $auth.submitLogin( $scope.teacher )
        .then( (resp) ->
          # handle success response
          $rootScope.USER = resp
          # console.log resp

          console.log $rootScope.USER
          
          $mdSidenav('left').toggle()
          alertify.success "Welcome back #{ $rootScope.USER.first_name }"
          $state.go "teacher/#{ $rootScope.USER.id }"
        )
        .catch( (resp) ->
          console.log "Login error"
          console.log resp
          alertify.error "Invalid credentials"
        )

    $scope.logout = ->
      $auth.signOut()
        .then( ( resp ) ->
          console.log resp
          alertify.success "Logged out successfully"
          $rootScope.USER = null
          $state.go 'welcome'
          $window.location.reload()
        ).catch( ( err ) ->
          console.log err
          $rootScope.USER = null
          alertify.error "Failed to log out"
        )
])
