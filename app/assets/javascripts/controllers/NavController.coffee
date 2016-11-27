'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  '$state'
  '$window'  
  '$mdSidenav'
  'alertify'
  'auth'
  '$auth'
  ( $scope, $rootScope, $state, $window,  $mdSidenav, alertify, auth, $auth ) ->
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
      auth.register( $scope.teacher ).then( ( resp ) ->
        $mdSidenav('left').toggle()
        
        alertify.success "Welcome #{ resp.data.data.email }"
      )

    $scope.login = ->
      auth.login( $scope.teacher ).then( ( resp ) ->
        console.log "logged in"
        $mdSidenav('left').toggle()
        if $rootScope.User.is_teacher then $state.go( "teacher", id: $rootScope.User.id ) else $state.go( "welcome" )
        alertify.success "Welcome back #{ $rootScope.User.first_name }"
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
