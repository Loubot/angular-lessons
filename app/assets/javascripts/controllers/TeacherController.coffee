'use strict'

angular.module('lessons').controller('TeacherController', [
  '$scope'
  '$rootScope'
  'User'
  'alertify'
  'COMMS'
  '$auth'
  'Upload'
  '$mdBottomSheet'
  '$mdDialog'
  '$mdToast'
  ( $scope, $rootScope, User, alertify, COMMS, $auth, Upload, $mdBottomSheet, $mdDialog, $mdToast ) ->
    console.log "TeacherController"

    display_subject_warning = ->
      alertify.error "Your profile is not visible till you select a subject" 

    display_subject_warning() if $rootScope.User.subjects.length==0

    $rootScope.$on 'no_subject_alert', ( a, b ) ->
      display_subject_warning()

    $scope.do_delete = ->
      COMMS.DELETE(
        "/auth"
      ).then( ( resp ) ->
        console.log resp
        $rootScope.User = null
        $state.go 'welcome'
      ).catch( ( err ) ->
        console.log err
      )

    
    $scope.open_delete = ->
      $mdDialog.show(
        templateUrl: "dialogs/delete_me.html"
        scope: $scope
        preserveScope: true
        
      )

    $scope.outta_here = ->
      $mdDialog.hide()
    

    ####################### Subjects ###############################

    $scope.get_subjects = ->
      console.log $scope.searchText
      COMMS.GET(
        '/subjects'
        search: $scope.searchText
      ).then( ( resp ) ->
        console.log resp
        # alertify.success "Got subjects"
        $scope.search_subjects = resp.data
        $scope.returned_subjects = true
        return resp.data.subjects
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to get subjects"
      )

    $scope.request_subject = ->
      $scope.no_subject.name = $rootScope.User.get_full_name()
      $scope.no_subject.email = $rootScope.User.email
      COMMS.POST(
        "/request-subject"
        $scope.no_subject
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Request made. Thank you."
        hide_sheet()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to send request"
        alertify.error "Please use the Contact Us button"
      )
    ####################### end of Subjects ###############################


   

    ####################### Sheets #######################################
    $scope.show_overview_sheet = ->
      $mdBottomSheet.show(
        templateUrl: "sheets/overview_sheet.html"
        controller: "TeacherController"
        scope: $scope
        preserveScope: true
      )

    $scope.show_qualification_sheet = ->
      $mdBottomSheet.show(
        templateUrl: "sheets/qualification_sheet.html"
        controller: "TeacherController"
        scope: $scope
        preserveScope: true
      )

    $scope.show_subject_request = ->

      $mdBottomSheet.show(
        templateUrl: "sheets/subject_request_sheet.html"
        controller: "TeacherController"
        scope: $scope
        preserveScope: true
      )

    hide_sheet = ->
      $mdBottomSheet.hide()


    ####################### end of sheets ################################


    ####################### Password #####################################
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
      $scope.announce_password_once = false
      $auth.updatePassword( $scope.update_password ).then((resp) ->
        console.log resp
        return
      ).catch (resp) ->
        console.log resp
        return

    $scope.$on 'auth:password-change-success', (ev) ->

      alertify.success 'Your password has been successfully updated!' if !$scope.announce_password_once
      $scope.announce_password_once = true
      $scope.closeDialog()
      $scope.update_password = null
      return

    $scope.$on 'auth:password-change-error', (ev, reason) ->
      $scope.closeDialog()
      $scope.update_password = null
      alertify.error 'Registration failed: ' + reason.errors[0]
      return
    ####################### End of password ##############################
])