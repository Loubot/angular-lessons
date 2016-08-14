'use strict'

angular.module('lessons').controller("RegisterController", [
  "$scope"

  ( $scope ) ->
    console.log "RegisterController"

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

        # $scope.register_teacher_form.$setPristine( true )
        
])