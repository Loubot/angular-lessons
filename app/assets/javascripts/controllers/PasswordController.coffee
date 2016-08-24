'use strict'

angular.module('lessons').controller( "PasswordController", [
  "$scope"
  "$rootScope"
  "$auth"
  "$http"
  "$stateParams"
  ( $scope, $rootScope, $auth, $http, $stateParams ) ->
    console.log "PasswordController"
    console.log $stateParams
    $scope.requestPasswordReset = ( pwdResetForm ) ->
      console.log pwdResetForm
      $auth.requestPasswordReset(pwdResetForm).then((resp) ->
        console.log resp
        return
      ).catch (resp) ->
        console.log resp
        return


      
      $http(
        url: "/api/auth/password"
        method: "POST"
        headers: { 
            "Content-Type": "application/json"
          }
        params:
          email: "lllouis@yahoo.com"
          redirect_url: "http://localhost:3000/#/reset-password///////"
          password: 
            email: "lllouis@yahoo.com"
            redirect_url: "http://localhost:3000/#/reset-password///////"

      ).then( ( resp ) ->
        console.log resp
      ).catch( ( err ) ->
        console.log err
      )

    # $scope.$on 'auth:password-reset-request-success', (ev, data) ->
    #   alert 'Password reset instructions were sent to ' + data.email
    #   console.log ev
    #   console.log data
    #   return

    # $scope.$on 'auth:password-reset-request-error', (ev, resp) ->
    #   alert 'Password reset request failed: ' + resp.errors[0]
    #   console.log ev
    #   console.log resp
    #   return

    # $rootScope.$on 'auth:password-reset-confirm-success', ->
    #   alert 'it worked'
    #   return

    # $scope.$on 'auth:password-reset-confirm-error', (ev, reason) ->
    #   console.log ev
    #   console.log reason
    #   alert 'Unable to verify your account. Please try again.'
    #   return

    # $scope.requestPasswordReset = ( a ) ->
    #   console.log $auth
      
])

# http://localhost:3000/?client_id=5qzNUaA__3Qlx9zrMEIygA&config=default&expiry=&reset_password=true&token=v_Uy3f9OM_C4ykSGpigomA&uid=lllouis%40yahoo.com#/view-teacher/10