'use strict'

angular.module('lessons').controller( "PasswordController", [
  "$scope"
  "$rootScope"
  "$auth"
  "$http"
  "$stateParams"
  "$state"
  "Alertify"
  ( $scope, $rootScope, $auth, $http, $stateParams, $state, Alertify ) ->
    console.log "PasswordController"
    console.log $stateParams
    $scope.disable_button = false
    $scope.requestPasswordReset = ( pwdResetForm ) ->
      $scope.disable_button = true
      console.log pwdResetForm
      $auth.requestPasswordReset(pwdResetForm).then((resp) ->
        console.log resp

        return
      ).catch (resp) ->
        console.log resp
        return

    $rootScope.$on 'a-user-is-logged-in', ( event, teacher ) ->
      console.log "user logged in"
      $state.go("teacher", id: teacher.id)
      
    $scope.$on 'auth:password-reset-request-success', (ev, data) ->
      Alertify.success 'Password reset instructions were sent to ' + data.email
      console.log ev
      console.log data
      return

    $scope.$on 'auth:password-reset-request-error', (ev, resp) ->
      Alertify.error 'Password reset request failed: ' + resp.errors[0]
      console.log ev
      console.log resp
      return

    $rootScope.$on 'auth:password-reset-confirm-success', ->
      Alertify.success "Temporary log in successful."
      Alertify.success "Please change your password immediately"
      $state.go "change_password"
      return

    $scope.$on 'auth:password-reset-confirm-error', (ev, reason) ->
      console.log ev
      console.log reason
      alert 'Unable to verify your account. Please try again.'
      return

    $scope.change_password = ->
      $auth.updatePassword($scope.changePasswordForm).then((resp) ->
        console.log resp
        return
      ).catch (resp) ->
        console.log resp
        return

    $scope.$on 'auth:password-change-success', (ev) ->
      Alertify.success 'Your password has been successfully updated!'
      return
    $scope.$on 'auth:password-change-error', (ev, reason) ->
      alert 'Registration failed: ' + reason.errors[0]
      return
      
])
