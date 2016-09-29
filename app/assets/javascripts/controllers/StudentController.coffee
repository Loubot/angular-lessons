'use strict'

angular.module('lessons').controller( 'StudentController', [
  '$scope'
  '$rootScope'
  '$stateParams'
  '$state'
  'USER'
  'alertify'
  'COMMS'
  '$mdDialog'
  '$auth'
  'Upload'
  'RESOURCES'

  ( $scope, $rootScope, $stateParams, $state, USER, alertify, COMMS, $mdDialog, $auth, Upload, RESOURCES ) ->
    console.log "StudentController"

    $scope.scrollevent = ( $e ) ->
      
      return

    $scope.upload = ( file ) ->
      Upload.upload(
        url: "#{ RESOURCES.DOMAIN }/teacher/#{ $rootScope.USER.id }/photos"
        file: $scope.file
        avatar: $scope.file
        data:
          avatar: $scope.file
      ).then( ( resp ) -> 
        console.log resp
        $rootScope.USER.photos = resp.data.photos if resp.data != ""
        console.log $rootScope.USER.photos
        alertify.success("Photo uploaded ok")
        if resp.data.status == "updated"
          $rootScope.USER = resp.data.teacher
          $rootScope.USER.photos = resp.data.photos if resp.data != ""
          profile_pic()
          alertify.success "Profile pic set"

        $scope.file = null
      ).catch( ( err ) ->
        console.log err
      )


    USER.get_user().then( ( user ) ->
      if $rootScope.USER.is_teacher
        alertify.error "You are not allowed to view this"
        $state.go "welcome"
        return
      profile_pic()
    ).catch( ( err ) ->
      alertify.error err
    )

    $scope.make_profile = ( id ) ->
      COMMS.POST(
        '/teacher'
        profile: id, id: $rootScope.USER.id
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Updated profile pic"
        if resp.data.status == "updated"
          $rootScope.USER = resp.data.teacher
          profile_pic()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to update profile"
      )

    profile_pic = ->
      console.log $rootScope.USER.photos
      if !$rootScope.USER.profile?
        console.log "No profile"
        $scope.profile = null
        return false
      for photo in $rootScope.USER.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $rootScope.USER.profile )
          $scope.profile = photo
          console.log $scope.profile
          $scope.profile

    $scope.destroy_pic = ( id ) ->
      COMMS.DELETE(
        "/teacher/#{ $rootScope.USER.id }/photos/#{ id }"
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Deleted photo ok"
        $rootScope.USER.photos = resp.data.teacher.photos
        $rootScope.USER.profile = resp.data.teacher.profile
        profile_pic()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to delete photo"
      )

    $scope.update_student = ->
      
      COMMS.POST(
        '/teacher'
        $rootScope.USER
      ).then( ( resp) ->
        console.log resp
        alertify.success "Updated your profile"
        $rootScope.USER = resp.data.teacher
        $state.go( 'teacher', id: $rootScope.USER.id ) if $scope.change_user_type
        # $mdBottomSheet.hide()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to update teacher"

      )

    $scope.change_to_teacher = ->
      $scope.change_user_type = true
      $scope.USER.is_teacher = true
      $scope.update_student()

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
      alertify.success 'Your password has been successfully updated!'
      $scope.closeDialog()
      $scope.update_password = null
      return

    $scope.$on 'auth:password-change-error', (ev, reason) ->
      $scope.closeDialog()
      $scope.update_password = null
      alertify.error 'Registration failed: ' + reason.errors[0]
      return

])