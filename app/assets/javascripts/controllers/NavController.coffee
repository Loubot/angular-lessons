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

    ### Opening closing menus ###

    $scope.open_login = ->
      $mdDialog.show(
        templateUrl: "dialogs/login.html"
        scope: $scope
        preserveScope: true
      )

    $scope.open_register_dialog = ->
      $mdDialog.show(
        templateUrl: "dialogs/register_student.html"
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

    ### Finish opening closing menus###
    $scope.facebook = ->
      console.log 'facebook'
      $auth.authenticate('facebook', {params: {resource_class: 'Teacher'}})
      # $auth.authenticate('facebook')
      
    
    ### Registration stuff ###
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

    $scope.register_student = ->
      console.log $scope.student.confirm_password
      $scope.student_form.confirm_password.$error.matching_password = false
      $scope.student_form.confirm_password.$error.requireds = false
      if $scope.student.confirm_password == "" or !$scope.student.confirm_password?
        
        console.log "nothing"
        $scope.student_form.confirm_password.$error.requireds = true
        
        console.log $scope.student_form


      else if $scope.student.password != $scope.student.confirm_password
        console.log "error"
        $scope.student_form.confirm_password.$error.matching_password = true
      else if $scope.student.password == $scope.student.confirm_password
        console.log "No error"
        $scope.student_form.confirm_password.$error.matching_password = false
        $scope.student_form.confirm_password.$error.requireds = false

        for att of $scope.student_form.confirm_password.$error
          if $scope.student_form.confirm_password.$error.hasOwnProperty(att)
            console.log att
            $scope.student_form.confirm_password.$setValidity att, true

        auth.register( $scope.student )

    $rootScope.$on 'auth:registered_user', ( user ) ->
      console.log user
      alertify.success "Student account created"
      $scope.close_dialog()

    ### End of registration stuff ###

  

    $scope.logout = ->
      auth.logout()

    $scope.close_dialog = ->
      $mdDialog.cancel()
])
