'use strict'

angular.module('lessons').controller("RegisterController", [
  "$scope"
  "$rootScope"
  "auth"
  "alertify"
  "COMMS"
  "counties"
  ( $scope, $rootScope, auth, alertify, COMMS, counties ) ->
    console.log "RegisterController"

    $scope.register_with_facebook = ->
      $auth.authenticate( 'facebook', { params: { resource_class: 'Teacher' } } )

    

    $scope.register_teacher = ->
      $scope.register_teacher_form.email2.$error.matching_email = false
      $scope.register_teacher_form.confirm_password.$error.matching_password = false
      if $scope.teacher.email != $scope.teacher.confirm_email
        console.log "Error"
        $scope.register_teacher_form.email2.$error.matching_email = true
        return false
      else if $scope.teacher.password != $scope.teacher.confirm_password

        console.log "no dice"
        $scope.register_teacher_form.confirm_password.$error.matching_password = true
        return false
      else
        console.log "No error"
        $scope.register_teacher_form.email2.$error.matching_email = false
        $scope.register_teacher_form.confirm_password.$error.matching_password = false
        
        # delete $scope.register_teacher_form.email2.$error.matching_email
        for att of $scope.register_teacher_form.email2.$error
          if $scope.register_teacher_form.email2.$error.hasOwnProperty(att)
            console.log att
            $scope.register_teacher_form.email2.$setValidity att, true

      $scope.teacher.is_teacher = true


      if !$scope.teacher.county?
        alertify.error "You must select your county"

      else
        console.log "made it"
        console.log $scope.teacher
        auth.register( $scope.teacher )

    # On successful registration create user location after user_ready is broadcast

    $rootScope.$on 'auth:registered_user', ( user ) ->
      alertify.success "Welcome #{ $rootScope.User.get_full_name() }"
      alertify.success "Registered as teacher" if $rootScope.User.is_teacher
      alertify.success "Registered as student" if !$rootScope.User.is_teacher
      # $state.go('teacher', id: $rootScope.User.id )
      $rootScope.User.create_location( county: $scope.teacher.county )
        
    # $scope.county_list = counties.county_list()

    $scope.county_lists = counties.county_list()

    # get_county = ( county ) ->
    #   console.log county
    #   console.log $scope.county_lists["#{ county }"]
    #   return $scope.county_lists["#{ county }"]

])