'use strict'

angular.module('lessons').controller( "PasswordController", [
  "$scope"
  "$rootScope"
  "$auth"
  "$http"
  "$stateParams"
  "$state"
  "alertify"
  ( $scope, $rootScope, $auth, $http, $stateParams, $state, alertify ) ->
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

    $scope.$on 'auth:password-reset-request-success', (ev, data) ->
      alertify.success 'Password reset instructions were sent to ' + data.email
      console.log ev
      console.log data
      return

    $scope.$on 'auth:password-reset-request-error', (ev, resp) ->
      alert 'Password reset request failed: ' + resp.errors[0]
      console.log ev
      console.log resp
      return

    $rootScope.$on 'auth:password-reset-confirm-success', ->
      alert 'it worked'
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
      alertify.success 'Your password has been successfully updated!'
      return
    $scope.$on 'auth:password-change-error', (ev, reason) ->
      alert 'Registration failed: ' + reason.errors[0]
      return
      
])

# http://localhost:3000/#/reset-password/5qzNUaA__3Qlx9zrMEIygA/default/expiry/true/aa574794553b09ce0becc3a394e97b194b6401796131f7590c5e8052c4513c7a/lllouis@yahoo.com/