'use strict'

angular.module('lessons').controller('TeacherController', [
  '$scope'
  '$rootScope'
  '$state'
  'RESOURCES'
  'USER'
  'User'
  'alertify'
  'COMMS'  
  '$stateParams'
  '$auth'
  'Upload'
  '$mdBottomSheet'
  '$mdDialog'
  ( $scope, $rootScope, $state, RESOURCES, USER, User, alertify, COMMS, $stateParams, $auth, Upload, $mdBottomSheet, $mdDialog ) ->
    console.log "TeacherController"
    $scope.photos = null
    console.log $rootScope.User


    
    $scope.upload = ( file ) ->
      $rootScope.User.upload_pic( $scope.file )


    
    USER.get_user().then( ( user ) ->
      USER.check_user()
      alertify.success "Got user"
      console.log $rootScope.USER.overview == null
      if $rootScope.USER.id != parseInt( $stateParams.id )
        $state.go 'welcome'
        alertify.error "You are not allowed to view this"
        return false
      

      $scope.subjects = $rootScope.USER.subjects
      alertify.error "Your profile is not visible until you select a subject" if $scope.subjects.length == 0
      alertify.error "Your profile might not be visible if you don't enter a location" if !$rootScope.USER.location?

      $scope.experience = $rootScope.USER.experience
      $scope.quals = $rootScope.USER.qualifications


    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
      $state.go 'welcome'
      return false
    )
    

    $scope.make_profile = ( id ) ->
      $rootScope.User.update_profile( id )
      

    $scope.destroy_pic = ( id ) ->
      $rootScope.User.delete_pic( id )


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

    $scope.select_subject = ( subject )->
      $rootScope.User.pick_subject( subject )

    $scope.remove_subject = ( subject ) ->
     $rootScope.User.delete_subject( subject )
    ####################### end of Subjects ###############################

    ####################### Experience ###################################

    $scope.add_experience = ->
      $scope.experience.teacher_id = $rootScope.USER.id
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/experience"
        $scope.experience
      ).then( ( resp ) ->
        console.log resp
        $scope.experience = resp.data.experience
        alertify.success "Experience added"
        # $scope.experience.description = null

      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to add experience"
      )

    $scope.remove_experience = ( experience ) ->
      COMMS.DELETE(
        "/experience/#{ experience.id }"
        experience
      ).then( ( resp ) ->
        console.log resp
        $scope.experience = resp.data.experience
        alertify.success "Removed experience"
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to delete subject"
      )

    ####################### end of experience ############################

    ####################### Update teacher #####################################
    $scope.update_teacher = ->

      $rootScope.User.update()
      
      # COMMS.POST(
      #   '/teacher'
      #   $scope.USER
      # ).then( ( resp) ->
      #   console.log resp
      #   alertify.success "Updated your profile"
      #   $rootScope.USER = resp.data.teacher
      #   $state.go( 'student_profile', id: $rootScope.USER.id ) if $scope.change_user_type
      #   $mdBottomSheet.hide()
      # ).catch( ( err ) ->
      #   console.log err
      #   alertify.error "Failed to update teacher"

      # )

    $scope.change_to_student = ->      

      
      $rootScope.User.change_user_type( false )

    ####################### End of update teacher ##############################

    ####################### Qualification ######################################
    $scope.create_qualification = ->
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/qualification"
        $scope.qualification
      ).then( ( resp ) ->
        console.log resp
        $scope.quals = resp.data.qualifications
        alertify.success "Created qualification"
        console.log $scope.quals
        $mdBottomSheet.hide()
      ).catch( ( err ) ->
        console.log err
        alertify.error err.errors.full_messages
      )
    ####################### End of qualification ###############################

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
      $auth.updatePassword($scope.update_password).then((resp) ->
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