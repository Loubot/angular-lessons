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

  ( $scope, $rootScope, $stateParams, $state, USER, alertify, COMMS, $mdDialog, $auth ) ->
    console.log "StudentController"

    $scope.scrollevent = ( $e ) ->
      
      return

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

    $scope.update_teacher = ->
      
      COMMS.POST(
        '/teacher'
        $rootScope.USER
      ).then( ( resp) ->
        console.log resp
        alertify.success "Updated your profile"
        $rootScope.USER = resp.data.teacher
        window.location.reload() if $scope.change_user_type
        # $mdBottomSheet.hide()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to update teacher"

      )

    $scope.change_to_student = ->
      $scope.change_user_type = true
      $scope.USER.is_teacher = false
      $scope.update_teacher()

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