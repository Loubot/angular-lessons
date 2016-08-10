'use strict'

angular.module('lessons').controller("RegisterController", [
  "$scope"

  ( $scope ) ->
    console.log "RegisterController"

    $scope.register_teacher = ->
      $scope.register_teacher_form.$setPristine();
      $scope.register_teacher_form.$setUntouched();
      if $scope.teacher.email != $scope.teacher.confirm_email
        console.log "Error"
        $scope.register_teacher_form.email2.$error.matching_email = true
      else
        $scope.register_teacher_form.email2.$error.matching_email = false

        console.log "No error"
])