'use strict'

angular.module('lessons').controller( 'StudentController', [
  '$scope'
  '$rootScope'
  '$stateParams'
  '$state'
  'User'
  'Alertify'
  'COMMS'
  '$mdDialog'
  '$auth'
  'Upload'
  'RESOURCES'

  ( $scope, $rootScope, $stateParams, $state, User, Alertify, COMMS, $mdDialog, $auth, Upload, RESOURCES ) ->
    console.log "StudentController"

    console.log $rootScope.User

    $scope.upload = ( file ) ->
      Upload.upload(
        url: "#{ RESOURCES.DOMAIN }/teacher/#{ $rootScope.USER.id }/photos"
        file: $scope.file
        avatar: $scope.file
        data:
          avatar: $scope.file
      ).then( ( resp ) -> 
        console.log resp
        $rootScope.User.photos = resp.data.photos if resp.data != ""
        console.log $rootScope.User.photos
        Alertify.success("Photo uploaded ok")
        if resp.data.status == "updated"
          $rootScope.User = resp.data.teacher
          $rootScope.User.photos = resp.data.photos if resp.data != ""
          profile_pic()

        $scope.file = null
      ).catch( ( err ) ->
        console.log err
      )


    profile_pic = ->
      console.log $rootScope.User.photos
      if !$rootScope.User.profile?
        console.log "No profile"
        $scope.profile = null
        return false
      for photo in $rootScope.User.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $rootScope.User.profile )
          $scope.profile = photo
          console.log $scope.profile
          $scope.profile

    $scope.change_to_teacher = ->
      
      
      $rootScope.User.change_user_type( true )

    $scope.open_change_password = ->
      console.log "Hup"
      $mdDialog.show(
        templateUrl: "dialogs/change_password.html"
        openFrom: '#left'
        closeTo: '#right'
        scope: $scope
        preserveScope: true

      )

    $scope.closeDialog = ->
      $mdDialog.hide()

    $scope.change_password = ->
      $auth.updatePassword($scope.update_password).then((resp) ->
        console.log resp
        return
      ).catch (resp) ->
        console.log resp
        return

    $scope.$on 'auth:password-change-success', (ev) ->
      Alertify.success 'Your password has been successfully updated!'
      $scope.closeDialog()
      $scope.update_password = null
      return

    $scope.$on 'auth:password-change-error', (ev, reason) ->
      $scope.closeDialog()
      $scope.update_password = null
      Alertify.error 'Registration failed: ' + reason.errors[0]
      return

])