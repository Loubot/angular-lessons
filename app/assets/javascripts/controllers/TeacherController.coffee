'use strict'

angular.module('lessons').controller('TeacherController', [
  '$scope'
  '$rootScope'
  '$state'
  'RESOURCES'
  'USER'
  'alertify'
  'COMMS'
  'FileUploader'
  '$stateParams'
  '$auth'
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, FileUploader, $stateParams, $auth ) ->
    console.log "TeacherController"
    x = $auth.retrieveData('auth_headers')
    x['X-CSRF-TOKEN'] = $('meta[name="csrf-token"]').attr('content')

    # x = $auth.retrieveData('auth_headers')
    # x['X-CSRF-TOKEN'] = $('meta[name="csrf-token"]').attr('content')
    # $scope.uploader = new FileUploader({
    #   headers : 
    #     x
    #     # $auth.retrieveData('auth_headers')
    #   url: "#{ RESOURCES.DOMAIN }/teacher/profile-pic"

    #   })
    

    USER.get_user().then( ( user ) ->
      alertify.success = "Got user"

      if $rootScope.USER.id != parseInt( $stateParams.id )
        $state.go 'welcome'
        alertify.error "You are not allowed to view this"
        return false

      COMMS.GET(
        "/teacher/profile"
        id: $rootScope.USER.id
      ).then( ( resp ) ->
        console.log resp
      ).catch( ( err ) ->
        console.log err
      )
    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
      return false
    )
])