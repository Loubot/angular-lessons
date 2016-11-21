angular.module('lessons').run [
  '$rootScope'
  "$http"
  ($rootScope, $http ) ->

    class User
      constructor: () ->
        @first_name = ''
        @last_name = ''
        @email = ''
        @id = null
        @location = null
        @qualifications = null
        @subjects = null

      set_user: ( user ) ->
        @.first_name = user.first_name
        @.last_name = user.last_name
        @.email = user.email
        @.id = user.id
        @location = user.location
        @qualifications = user.qualifications
        @subjects = user.subjects


    $rootScope.$on 'auth:validation-success', ( e ) ->
      console.log 'validation success'
      console.log $rootScope.user
      u = new User()
      console.log u
      $http(
        method: "GET"
        url: "/api/teacher/#{ $rootScope.user.id }"
      ).then( ( resp ) ->
        console.log resp
        u.set_user( $rootScope.user )
        console.log u
      ).catch( ( err ) ->
        console.log err
      )

      

    $rootScope.$on 'auth:validation-error', ( e ) ->
      console.log 'validation error '
      console.log e

    $rootScope.$on 'auth-login-success', ( e, user ) ->
      console.log 'login'
      console.log e
      console.log user

]