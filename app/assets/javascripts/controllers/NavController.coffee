'use strict'

angular.module('lessons').controller('NavController', [
  '$scope'
  '$rootScope'
  '$state'
  '$window'  
  '$mdSidenav'
  '$mdMenu'
  '$mdDialog'
  'Alertify'
  'auth'
  '$auth'
  'COMMS'
  ( $scope, $rootScope, $state, $window, $mdSidenav, $mdMenu, $mdDialog, Alertify, auth, $auth, COMMS ) ->
    console.log "NavController"
    $scope.teacher = {}

    # Get subjects for subjects menu

    COMMS.GET(
        '/search-subjects'
    ).then( ( resp ) ->
      # console.log resp
      
      $rootScope.subject_list_for_menu = resp.data.subjects
      # define_subjects( resp.data.subjects )
    ).catch( ( err ) ->
      console.log err
    )

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
        

    $scope.open_home_menu = ( $mdOpenMenu, e ) -> #This $mdOpenMenu is actually $mdMenu.open being passed from html
      # console.log e
      $mdOpenMenu( e )

    $scope.open_subjects_menu = ( $mdOpenMenu, e ) -> #This $mdOpenMenu is actually $mdMenu.open being passed from html
      # console.log e
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
        
        Alertify.success "Welcome #{ $rootScope.User.email }"
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to register"
      )

    $scope.register_student = ->
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
      Alertify.success "Student account created"
      $scope.close_dialog()

    ### End of registration stuff ###

  

    $scope.logout = ->
      auth.logout()

    $scope.close_dialog = ->
      $mdDialog.cancel()

])
