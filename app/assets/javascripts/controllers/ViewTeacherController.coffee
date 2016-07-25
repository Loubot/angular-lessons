'use strict'

angular.module('lessons').controller( 'ViewTeacherController', [
  "$scope"
  "$rootScope"
  "$state"
  "$stateParams"
  "USER"
  "$filter"
  "COMMS"
  "alertify"
  ( $scope, $rootScope, $state, $stateParams, USER, $filter, COMMS, alertify ) ->
    console.log "ViewTeacherController"
    $scope.scrollevent = ( $e ) ->
      
      # animate_elems()
      # @scrollPos = document.body.scrollTop or document.documentElement.scrollTop or 0
      # $scope.$digest()
      return


    USER.get_user().then( ( user ) ->
      COMMS.GET(
        "/teacher/#{ $stateParams.id }/show-teacher"
      ).then( ( resp ) ->
        console.log resp
        $scope.teacher = resp.data.teacher
        set_profile()
      ).catch( ( err ) ->
        console.log err
        alertify.error err.data.errors.full_messages
      )
    )


    set_profile = ->
      for photo in $scope.teacher.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $scope.teacher.profile )
          # console.log photo
          $scope.profile = photo
          # console.log $scope.profile
          $scope.profile

    
])