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
  ( $scope, $rootScope, $state, $window, $mdSidenav, alertify, auth, $auth ) ->
    console.log "NavController"
    $scope.teacher = {}
    $scope.auth_type = null

    $scope.auth = auth

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
      auth.login( $scope.teacher )

    # Successful login will trigger user_ready event. user.js
    $rootScope.$on 'user_ready', ( ( user) ->
      console.log 'User event'
      $mdSidenav('left').close()
      if $rootScope.User.is_teacher then $state.go( "teacher", id: $rootScope.User.id ) else $state.go( "welcome" )
      alertify.success "Welcome back #{ $rootScope.User.first_name }"      
    )

    $scope.logout = ->
      auth.logout()
])
