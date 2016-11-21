angular.module('lessons').run [
  '$rootScope'
  ($rootScope) ->


    User = ( user ) ->
      @.first_name = user.first_name
      @.last_name = user.last_name
      @.email = user.email

    User::get_full_name = ->
      @.first_name + ' ' + @.last_name

    $rootScope.$on 'auth:validation-success', ( e ) ->
      console.log 'validation success'
      console.log $rootScope.user
      u =  new User( $rootScope.user )
      console.log u.get_full_name()

    $rootScope.$on 'auth:validation-error', ( e ) ->
      console.log 'validation error '
      console.log e

    $rootScope.$on 'auth-login-success', ( e, user ) ->
      console.log 'login'
      console.log e
      console.log user

]