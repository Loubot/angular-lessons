'use strict'

angular.module('lessons').controller("RegisterController", [
  "$scope"
  "$rootScope"
  "$state"
  "$auth"
  "alertify"

  ( $scope, $rootScope, $state, $auth, alertify) ->
    console.log "RegisterController"

    $scope.scrollevent = ( $e ) ->
      
      

    $scope.register_teacher = ->
      if $scope.teacher.email != $scope.teacher.confirm_email
        console.log "Error"
        $scope.register_teacher_form.email2.$error.matching_email = true
      else
        console.log "No error"
        $scope.register_teacher_form.email2.$error.matching_email = false
        # delete $scope.register_teacher_form.email2.$error.matching_email
        for att of $scope.register_teacher_form.email2.$error
          if $scope.register_teacher_form.email2.$error.hasOwnProperty(att)
            console.log att
            $scope.register_teacher_form.email2.$setValidity att, true

      $auth.submitRegistration( $scope.teacher )
        .then( (resp) ->
          # handle success response
          # console.log resp.data.data
          $rootScope.USER = resp.data.data
          console.log $rootScope.USER
          $state.go 'welcome'
          alertify.success "Welcome #{ resp.data.data.email }"
        )
        .catch( (resp) ->
          # handle error response
          console.log resp
          alertify.error "Failed to register"
          
        )
        
])