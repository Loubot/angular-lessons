'use strict'

angular.module('lessons').controller('TeacherController', [
  '$scope'
  '$rootScope'
  'User'
  'RESOURCES'
  'Alertify'
  'COMMS'
  '$auth'
  'Upload'
  '$mdBottomSheet'
  '$mdDialog'
  '$mdToast'
  ( $scope, $rootScope, User, RESOURCES, Alertify, COMMS, $auth, Upload, $mdBottomSheet, $mdDialog, $mdToast ) ->
    console.log "TeacherController"

    
    $scope.price_options = ( x for x in [ 0..150 ] by 5 )
    $scope.time_options = ( x for x in [ 0..120 ] by 15 )

    display_subject_warning = ->
      Alertify.error "Your profile is not visible till you select a subject" 

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
        # Alertify.success "Got subjects"
        $scope.search_subjects = resp.data
        $scope.returned_subjects = true
        return resp.data.subjects
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to get subjects"
      )

    $scope.request_subject = ->
      $scope.no_subject.name = $rootScope.User.get_full_name()
      $scope.no_subject.email = $rootScope.User.email
      COMMS.POST(
        "/request-subject"
        $scope.no_subject
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Request made. Thank you."
        hide_sheet()
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to send request"
        Alertify.error "Please use the Contact Us button"
      )
    ####################### end of Subjects ###############################
   

    ####################### Sheets #######################################
    $scope.show_overview_sheet = ->
      $mdBottomSheet.show(
        templateUrl: "sheets/overview_sheet.html"
        scope: $scope
        preserveScope: true
      )

    $scope.show_qualification_sheet = ->
      $mdBottomSheet.show(
        templateUrl: "sheets/qualification_sheet.html"
        scope: $scope
        preserveScope: true
      )

    $scope.show_subject_request = ->

      $mdBottomSheet.show(
        templateUrl: "sheets/subject_request_sheet.html"
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

      Alertify.success 'Your password has been successfully updated!' if !$scope.announce_password_once
      $scope.announce_password_once = true
      $scope.closeDialog()
      $scope.update_password = null
      return

    $scope.$on 'auth:password-change-error', (ev, reason) ->
      $scope.closeDialog()
      $scope.update_password = null
      Alertify.error 'Registration failed: ' + reason.errors[0]
      return

    ### Submit user form. This enables validations on phone number to run. ###
    $scope.update_teacher = -> 
      $rootScope.User.update() if $scope.teacher_update_form.$valid
    ####################### End of password ##############################

    ####################### Upload proof #################################

    $scope.upload_proof = ( proof ) ->
      Upload.upload(
        url: "#{ RESOURCES.DOMAIN }/teacher/#{ $rootScope.User.id }/garda-vetting"
        file: proof
        # avatar: pic
        # data:
        #   avatar: pic
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Uploaded successfully"
        $mdDialog.cancel()
        $scope.proof = null
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to upload"
      )

    $scope.open_email_proof_dialog = ->
      $mdDialog.show(
        templateUrl: "dialogs/email_proof.html"
        scope: $scope
        preserveScope: true
        
      )

    $scope.close_dialog = ->
      $mdDialog.cancel()


    ####################### End of upload proof ##########################
])