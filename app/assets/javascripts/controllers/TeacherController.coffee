'use strict'

angular.module('lessons').controller('TeacherController', [
  '$scope'
  '$rootScope'
  '$state'
  'RESOURCES'
  'USER'
  'alertify'
  'COMMS'  
  '$stateParams'
  '$auth'
  'Upload' 
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, $stateParams, $auth, Upload ) ->
    console.log "TeacherController"
    $scope.photos = null
   
    
    $scope.upload = ( file ) ->
      Upload.upload(
        url: "#{ RESOURCES.DOMAIN }/teacher/profile-pic"
        file: file
        avatar: file
        data:
          avatar: file
          id: $rootScope.USER
      ).then( ( resp ) -> 
        console.log resp
      )



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
        $scope.photos = resp.data.photos
      ).catch( ( err ) ->
        console.log err
      )
    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
      return false
    )
])