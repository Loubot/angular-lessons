'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  '$state'
  '$window'  
  '$mdSidenav'
  '$mdMenu'
  '$mdDialog'
  'alertify'
  'auth'
  '$auth'
  ( $scope, $rootScope, $state, $window, $mdSidenav, $mdMenu, $mdDialog, alertify, auth, $auth ) ->
    console.log "NavController"
    $scope.teacher = {}

    $scope.open_login = ->
      $mdDialog.show(
        templateUrl: "dialogs/login.html"
        scope: $scope
        preserveScope: true
      )

    $scope.open_register = ->
      $mdDialog.show(
        templateUrl: "dialogs/student_register.html"
        scope: $scope
        preserveScope: true
      )
        

    $scope.open_home_menu = ( $mdOpenMenu, e ) ->
      console.log e
      $mdOpenMenu( e )

    $scope.open_subjects_menu = ( $mdOpenMenu, e ) ->
      console.log e
      $mdOpenMenu( e )

    $scope.auth = auth

    $scope.facebook = ->
      console.log 'facebook'
      $auth.authenticate('facebook', {params: {resource_class: 'Teacher'}})
      # $auth.authenticate('facebook')
      
    
    $scope.register_teacher = ->
      
      $scope.teacher.is_teacher = true if $scope.auth_type == 1
      console.log $scope.teacher
      console.log $scope.auth_type
      auth.register( $scope.teacher ).then( ( resp ) ->
        $mdSidenav('left').toggle()
        
        alertify.success "Welcome #{ $rootScope.User.email }"
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to register"
      )

  

    $scope.logout = ->
      auth.logout()

    $scope.close_dialog = ->
      $mdDialog.cancel()
])
